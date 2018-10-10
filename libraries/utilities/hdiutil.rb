module MacOS
  class Hdiutil
    class << self
      def attach(*args)
        [base_command, 'attach', args].join ' '
      end

      def convert(*args)
        [base_command, 'convert', args].join ' '
      end

      def create(*args)
        [base_command, 'create', args].join ' '
      end

      def device_node(disk_image)
        attach_output = `#{attach(disk_image)}`
        attach_output.split.first
      end

      def base_command
        File.join '/', 'usr', 'bin', 'hdiutil'
      end
    end
  end
end
