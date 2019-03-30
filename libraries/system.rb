module MacOS
  module System
    class FormFactor
      attr_reader :machine_model

      def initialize(hardware)
        @machine_model = hardware.nil? ? nil : hardware['machine_model']
      end

      def desktop?
        return false if @machine_model.nil?
        @machine_model.match? Regexp.union %w(Macmini MacPro iMac)
      end

      def portable?
        return false if @machine_model.nil?
        @machine_model.match? Regexp.union %w(MacBook)
      end
    end

    class Environment
      attr_reader :virtualization_systems

      def initialize(virtualization_systems)
        @virtualization_systems = virtualization_systems
      end

      def vm?
        @virtualization_systems.empty? || @virtualization_systems.values.include?('guest') ? true : false
      end
    end

    class ScreenSaver
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def disabled?
        shell_out('defaults -currentHost read com.apple.screensaver idleTime', user: @user).stdout.chomp == '0' &&
          shell_out('defaults -currentHost read-type com.apple.screensaver idleTime', user: @user).stdout.chomp == 'Type is integer'
      end
    end
  end
end

Chef::Recipe.include(MacOS::System)
Chef::Resource.include(MacOS::System)
Chef::DSL::Recipe.include(MacOS::System)
