module MacOS
  module System
    class FormFactor
      attr_reader :machine_model

      def initialize(machine_model = nil)
        @machine_model = if Chef.node['hardware']['machine_model'].nil?
                           machine_model
                         else
                           Chef.node['hardware']['machine_model']
                         end
      end

      def desktop?
        return false if @machine_model.nil?
        Chef.node['hardware']['machine_model'].match? Regexp.union %w(MacMini MacPro iMac)
      end

      def portable?
        return false if @machine_model.nil?
        Chef.node['hardware']['machine_model'].match? Regexp.union %w(Macbook)
      end
    end

    class Environment
      attr_reader :virtualization_systems

      def initialize(virtualization_systems = nil)
        @virtualization_systems = if Chef.node['virtualization']['systems'].nil?
                                    virtualization_systems
                                  else
                                    Chef.node['virtualization']['systems']
                                  end
      end

      def vm?
        @virtualization_systems.empty? || @virtualization_systems.values.include?('guest') ? true : false
      end
    end

    class ScreenSaver
      def initialize
      end

      def disabled?
        settings('read', '0') &&
          settings('read-type', 'integer')
      end

      def settings(query_type, expected_value)
        regex_value = query_type == 'read' ? "/^[#{expected_value}]+$/" : expected_value
        expression_pattern = Regexp.new(regex_value)
        query(query_type).stdout.chomp.match?(expression_pattern)
      end

      def query(query_type)
        shell_out('defaults', '-currentHost', query_type, 'com.apple.screensaver', 'idleTime',
        user: Chef.node['macos']['admin_user'])
      end
    end
  end
end

Chef::Recipe.include(MacOS::System)
Chef::Resource.include(MacOS::System)
Chef::DSL::Recipe.include(MacOS::System)
