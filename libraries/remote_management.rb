module MacOS
  class RemoteManagement
    class << self
      # macos::remote_management load_current_value helper
      # the privileges property will be an integer mask
      # compare this to the current mask of each user specified in the users property.
      # Return empty string if any user still needs to set up privileges. The resource will converge.
      # Return empty string if users have different masks. The resource will converge.
      # Return an integer mask if the users share the same mask. The resource will NOT converge if the desired mask matches this mask.
      def current_mask(*users)
        configured_for_all_users? ? current_global_mask(users) : current_user_masks(users)
      end

      def current_global_mask(users)
        global_settings_privilege_value.nil? ? current_user_masks(users) : BitMask.mask_from_value(global_settings_privilege_value)
      end

      def current_user_masks(users)
        all_user_masks_hash = individual_settings
        specified_user_masks = users.include?('all') ? all_user_masks_hash.values : users.map { |user| all_user_masks_hash.fetch(user) }
        specified_user_masks.uniq.one? ? specified_user_masks.first : ''
      rescue KeyError
        ''
      end

      def current_computer_info
        computer_info_hash.select { |k, _v| k.match?(Regexp.new('Text')) }.values.reject(&:empty?)
      end

      def activated?
        agent_running? && correct_tccstate?
      end

      def kickstart
        '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'
      end

      private

      def agent_running?
        ::File.exist?('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
      end

      def configured_for_all_users?
        global_settings&.[]('ARD_AllLocalUsers')
      end

      def global_settings_privilege_value
        global_settings&.[]('ARD_AllLocalUsersPrivs')
      end

      def global_settings
        ::Plist.parse_xml(global_settings_xml)
      end

      def global_settings_xml
        shell_out!('/usr/bin/plutil -convert xml1 /Library/Preferences/nasgul.apple.RemoteManagement.plist -o -').stdout
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
      rescue Mixli::ShellOut::ShellCommandFailed => e
        e.message.match?(Regexp.new('file does not exist')) ? '' : raise
      end

      def computer_info_hash
        ::Plist.parse_xml(computer_info_xml)
      end
    end

    module TCC
      module State
        def enabled?
          post_event_service_enabled? && screencapture_service_enabled?
        end

        def post_event_service_enabled?
          hash&.[]('postEvent')
        end

        def screencapture_service_enabled?
          hash&.[]('screenCapture')
        end

        private

        def hash
          ::Plist.parse_xml(tccstate_xml)
        end

        def xml
          shell_out!('sudo', '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/tccstate').stdout
        end
      end

      module DB
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

      class << self
        def valid_mask?(mask)
          value = value_from_mask(mask)
          return true if value == NONE
          (~(ALL | OBSERVE_ONLY) & value).zero?
        end

        def valid_privileges?(privileges)
          invalid_privileges(privileges).empty?
        end

        def invalid_privileges(privileges)
          privileges - constants(false)
        end

        def validate_privileges!(privileges)
          raise RemoteManagement::Exceptions::BitMask::PrivilegeValidationError unless valid_privileges?(privileges)
        rescue RemoteManagement::Exceptions::BitMask::PrivilegeValidationError # raise property validation error if called from propery coersion block
          called_by_chef_property_coerce ? raise(Chef::Exceptions::ValidationFailed, "Option privilege's value is invalid. See https://ss64.com/osx/kickstart.html for valid privileges!") : raise
        end

        def called_by_chef_property_coerce
          caller_locations.any? { |backtrace_location| ::File.basename(backtrace_location.path, '.rb') == 'property' && backtrace_location.label == 'coerce' }
        end

        def value_from_privileges(privileges)
          privileges = format_privileges(privileges)
          validate_privileges!(privileges)

          return ALL if privileges.include?(:ALL)
          return 0 if privileges.include?(:NONE)
          privileges.map { |priv| const_get(priv.upcase) }.reduce(&:|)
        end

        def format_privileges(privileges)
          [privileges].flatten.map { |privilege| privilege.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/(\s|-|_{2,})/, '_').upcase.to_sym }
        end

        def mask_from_value(value)
          value - NONE
        end

        def value_from_mask(mask)
          mask + NONE
        end

        def mask_from_privileges(privileges)
          value = value_from_privileges(privileges)
          mask_from_value(value)
        end
      end
    end

    module Exceptions
      class TCCError < RuntimeError
        def initialize
          super(message)
        end

        def message
          String.new.tap do |message|
            message << "TCC does not have the correct authorizations for ARD to work!\n"
            message << "\t* Screensharing client not authorized for post event service\n" unless RemoteManagement.screensharing_client_authorized_for_post_event_service?
            message << "\t* Screensharing client not authorized for screencapture service\n" unless RemoteManagement.screensharing_client_authorized_for_screencapture_service?
          end
        end
      end

      module BitMask
        class PrivilegeValidationError < ArgumentError
          def initialize
            super("recieved invalid privilege! Valid privileges include: #{RemoteManagement::BitMask.constants(false).map(&:downcase).map(&:to_s)}")
          end
        end
      end
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
