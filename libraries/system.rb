module MacOS
  module System
    class FormFactor
      attr_reader :machine_model

      def initialize(hardware)
        @machine_model = hardware.nil? ? nil : hardware['machine_model']
      end

      def desktop?
        return false if @machine_model.nil?
        @machine_model.match? Regexp.union ['Macmini', 'MacPro', 'iMac', /Mac\d/]
      end

      def portable?
        return false if @machine_model.nil?
        @machine_model.match? Regexp.union ['MacBook']
      end
    end

    class Environment
      attr_reader :virtualization_systems

      def initialize(virtualization_systems)
        @virtualization_systems = virtualization_systems
      end

      def vm?
        @virtualization_systems.value?('guest')
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

  class Platform
    attr_reader :version
    attr_reader :build

    def initialize(hardware)
      @version = hardware.nil? ? nil : hardware['operating_system_version']
      @build = hardware.nil? ? nil : hardware['build_version']
    end

    def beta?
      @version.chars.last.match?(/0/) && @build.chars.last.match?(/[[:alpha:]]/)
    end
  end
end

Chef::Resource.include(MacOS::System)
Chef::DSL::Recipe.include(MacOS::System)
