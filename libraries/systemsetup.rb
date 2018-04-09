module MacOS
  module System
    class Power
      def initialize
      end

      def running_in_a_vm?
        virtualization_systems = Chef.node['virtualization']['systems']
        virtualization_systems.empty? || virtualization_systems.values.include?('guest') ? true : false
      end

      def power_button_model?
        Chef.node['hardware']['machine_model'].match? Regexp.union %w(Macmini MacPro)
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
