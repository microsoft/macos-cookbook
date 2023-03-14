module MacOS
  class RemoteManagement
    class << self
      def current_mask(users)
        using_global_privileges? ? Privileges::Value.new(value: global_settings_privilege_value).to_mask : current_user_masks(users).first
      end

      def current_user_masks(users)
        users = all_local_users if users.include?('all')
        users.flatten.map { |user| Privileges::Mask.new(mask: individual_settings.fetch(user)) }
      end

      def current_users_have_identical_masks?(users)
        return true if using_global_privileges?
        current_user_masks(users).map(&:to_i).uniq.one?
      end

      def current_users_configured?(users)
        return true if using_global_privileges?
        users = all_local_users if users.include?('all')
        (users - individual_settings.keys).empty?
      end

      def current_computer_info
        computer_info_hash.select { |k, _v| k.match?(Regexp.new('Text')) }.values.reject(&:empty?)
      end

      def activated?
        agent_running? && TCC::State.enabled?
      end

      def kickstart
        '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'
      end

      private

      def agent_running?
        ::File.exist?('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
      end

      def using_global_privileges?
        using_global_settings? && !global_settings_privilege_value.nil?
      end

      def using_global_settings?
        global_settings['ARD_AllLocalUsers'] || false
      end

      def global_settings_privilege_value
        global_settings['ARD_AllLocalUsersPrivs']
      end

      def global_settings
        ::Plist.parse_xml(global_settings_xml) || {}
      end

      def global_settings_xml
        shell_out!('/usr/bin/plutil -convert xml1 /Library/Preferences/com.apple.RemoteManagement.plist -o -').stdout
      rescue Mixlib::ShellOut::ShellCommandFailed => e
        e.message.match?(Regexp.new('file does not exist')) ? '' : raise
      end

      def individual_settings
        dscl_naprivs.scan(/(?<user>^\S+)\s+(?<mask>-\d+)/).to_h.transform_values(&:to_i)
      end

      def dscl_naprivs
        shell_out!('/usr/bin/dscl . -list /Users dsAttrTypeNative:naprivs').stdout
      end

      def computer_info_xml
        shell_out!('/usr/bin/plutil -convert xml1 /Library/Preferences/com.apple.RemoteDesktop.plist -o -').stdout
      rescue Mixlib::ShellOut::ShellCommandFailed => e
        e.message.match?(Regexp.new('file does not exist')) ? '' : raise
      end

      def computer_info_hash
        ::Plist.parse_xml(computer_info_xml) || {}
      end

      def all_local_users
        system_users = %w(root nobody daemon unknown smmsp www mysql sshd lp sendmail postfix eppc qtss cyrus mailman)
        (all_users.reject { |user| user.match?(/^_\w+$/) } - system_users)
      end

      def all_users
        shell_out!('/usr/bin/dscl . -list /Users').stdout.split
      end
    end

    module TCC
      module State
        class << self
          def enabled?
            post_event_service_enabled? && screencapture_service_enabled?
          end

          def post_event_service_enabled?
            hash['postEvent'] || false
          end

          def screencapture_service_enabled?
            hash['screenCapture'] || false
          end

          private

          def hash
            ::Plist.parse_xml(xml) || {}
          end

          def xml
            shell_out!('sudo', '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/tccstate').stdout
          end
        end
      end

      module DB
        class << self
          def correct_privileges?
            screensharing_client_authorized_for_post_event_service? && screensharing_client_authorized_for_screencapture_service?
          end

          def screensharing_client_authorized_for_post_event_service?
            screensharing_client_auth_value_for_post_event_service == 2
          end

          def screensharing_client_authorized_for_screencapture_service?
            screensharing_client_auth_value_for_screencapture_service == 2
          end

          private

          def path
            '/Library/Application Support/com.apple.TCC/TCC.db'
          end

          def screensharing_client_auth_value_for_post_event_service
            shell_out!('/usr/bin/sqlite3', path, "SELECT auth_value FROM access WHERE service='kTCCServicePostEvent' AND client='com.apple.screensharing.agent';").stdout.chomp.to_i
          end

          def screensharing_client_auth_value_for_screencapture_service
            shell_out!('/usr/bin/sqlite3', path, "SELECT auth_value FROM access WHERE service='kTCCServiceScreenCapture' AND client='com.apple.screensharing.agent';").stdout.chomp.to_i
          end
        end
      end
    end

    module Privileges
      class << self
        def valid?(*privileges)
          list_invalid([privileges].flatten).empty?
        end

        def validate!(*privileges)
          raise(Exceptions::Privileges::ValidationError, list_invalid(privileges)) unless valid?(privileges)
        rescue Exceptions::Privileges::ValidationError => e # raise property validation error if called from property coercion block
          called_by_chef_property_coerce? ? raise(Chef::Exceptions::ValidationFailed, e.message) : raise
        end

        def format(*privileges)
          [privileges].flatten.map do |privilege|
            privilege.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                     .gsub(/([a-z])([A-Z])/, '\1_\2')
                     .gsub(/(\s|-|_{2,})/, '_')
                     .upcase.to_sym
          end
        end
 
        private

        def called_by_chef_property_coerce?
          caller_locations.any? { |backtrace_location| ::File.basename(backtrace_location.path, '.rb') == 'property' && backtrace_location.label == 'coerce' }
        end

        def list_invalid(privileges)
          privileges - BitMask.constants(false)
        end
      end

      class Value
        extend Forwardable
        def_delegators :@value, :to_i, :zero?, :==, :+, :-, :|, :&, :^

        def initialize(value: nil, privileges: nil)
          if value
            raise(Exceptions::Privileges::Value::ValidationError, value) unless valid?(value)
            @value = value
          elsif privileges
            privileges = Privileges.format(privileges)
            Privileges.validate!(privileges)
            @value = from_privileges(privileges)
          else
            raise(Exceptions::Privileges::Value::InvalidArgument, value, privileges)
          end
        end

        def valid?(value)
          return true if value == BitMask::NONE
          (~(BitMask::ALL | BitMask::OBSERVE_ONLY) & value).zero?
        end

        def from_privileges(privileges)
          return BitMask::ALL if privileges.include?(:ALL)
          return 0 if privileges.include?(:NONE)
          privileges.map { |priv| BitMask.const_get(priv.upcase) }.reduce(&:|)
        end

        def to_mask
          Mask.new(mask: (@value - BitMask::NONE))
        end

        def to_a
          return ['none'] if @value.zero?
          return ['all'] if @value == BitMask::ALL
          unformated_priv_strings = BitMask.constants(false).reject { |const| (BitMask.const_get(const) & @value).zero? || const == :ALL }.map(&:to_s).map(&:downcase)
          unformated_priv_strings.map { |priv| priv.to_s.split('_').map(&:capitalize).join }
        end

      end

      class Mask
        extend Forwardable
        def_delegators :@mask, :to_i, :zero?, :==, :+, :-, :|, :&, :^

        def initialize(mask: nil, privileges: nil)
          if mask
            raise(Exceptions::Privileges::Value::ValidationError, mask) unless valid?(mask)
            @mask = mask
          elsif privileges
            privileges = Privileges.format(privileges)
            Privileges.validate!(privileges)
            @mask = from_privileges(privileges)
          else
            raise(Exceptions::Privileges::Value::InvalidArgument, mask, privileges)
          end
        end

        def valid?(mask)
          return true if mask.zero?
          (~(BitMask::ALL | BitMask::OBSERVE_ONLY) & (mask + BitMask::NONE)).zero?
        end

        def from_privileges(privileges)
          return -BitMask::NONE if privileges.include?(:NONE)
          return (BitMask::ALL - BitMask::NONE) if privileges.include?(:ALL)
          (privileges.map { |priv| BitMask.const_get(priv.upcase) }.reduce(&:|) - BitMask::NONE)
        end

        def to_value
          Value.new(value: (@mask + BitMask::NONE))
        end

        def to_a
          return ['none'] if (@mask + BitMask::NONE).zero?
          return ['all'] if @mask + BitMask::NONE == BitMask::ALL
          unformated_priv_strings = BitMask.constants(false).reject { |const| (BitMask.const_get(const) & (@mask + BitMask::NONE)).zero? || const == :ALL }
          unformated_priv_strings.map { |priv| priv.to_s.split('_').map(&:capitalize).join }
        end

        # For Chef logging
        # Chef logs without this overide -> 'set privileges to MacOS::RemoteManagement::Privileges::Mask:0x00007fe032914c08 @mask=-2147483641> (was #<MacOS::RemoteManagement::Privileges::Mask:0x00007fe0329d7f78 @mask=-2147483645>)'
        # Chef logs with this override -> 'set privileges to ["TextMessages", "ControlObserve"] (was ["TextMessages", "ControlObserve", "SendFiles"])'
        def inspect
          to_a.to_s
        end
      end
    end

    module BitMask
      TEXT_MESSAGES     = 0b00000000000000000000000000000001
      CONTROL_OBSERVE   = 0b00000000000000000000000000000010
      SEND_FILES        = 0b00000000000000000000000000000100
      DELETE_FILES      = 0b00000000000000000000000000001000
      GENERATE_REPORTS  = 0b00000000000000000000000000010000
      OPEN_QUIT_APPS    = 0b00000000000000000000000000100000
      CHANGE_SETTINGS   = 0b00000000000000000000000001000000
      RESTART_SHUT_DOWN = 0b00000000000000000000000010000000
      OBSERVE_ONLY      = 0b00000000000000000000000100000000
      SHOW_OBSERVE      = 0b01000000000000000000000000000000
      ALL               = 0b01000000000000000000000011111111
      NONE              = 0b10000000000000000000000000000000
    end

    module Exceptions
      class TCCError < RuntimeError
        def initialize
          super(message)
        end

        def message
          String.new.tap do |message|
            message << "TCC does not have the correct authorizations for ARD to work!\n"
            message << "\t* Screensharing client not authorized for post event service\n" unless RemoteManagement::TCC::DB.screensharing_client_authorized_for_post_event_service?
            message << "\t* Screensharing client not authorized for screencapture service\n" unless RemoteManagement::TCC::DB.screensharing_client_authorized_for_screencapture_service?
          end
        end
      end

      module Privileges
        class ValidationError < ArgumentError
          def initialize(invalid_privileges)
            super("#{invalid_privileges.map(&:to_s).map(&:downcase)} are invalid privilege(s)! Valid privileges include: #{RemoteManagement::BitMask.constants(false).map(&:downcase).map(&:to_s)}")
          end
        end

        module Value
          class ValidationError < ArgumentError
            def initialize(value)
              super("#{value.inspect} is an invalid value!")
            end
          end

          class InvalidArgument < ArgumentError
            def initialize(*args)
              super("wrong number of arguments (given #{args.compact.size} expected 1)")
            end
          end
        end

        module Mask
          class ValidationError < ArgumentError
            def initialize(mask)
              super("#{mask.inspect} is an invalid mask!")
            end

            class InvalidArgument < ArgumentError
              def initialize(*args)
                super("wrong number of arguments (given #{args.compact.size} expected 1)")
              end
            end
          end
        end
      end
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
