include Chef::Mixin::ShellOut

module MacOS
  class CommandLineTools
    attr_reader :version

    def initialize
      @version = if available_command_line_tools.empty?
                   'none'
                 else
                   available_command_line_tools.last.tr('*', '').strip
                 end
    end

    def available_command_line_tools
      available_products.lines.select { |s| s.include?('* Command') }
    end

    def available_products
      shell_out(['softwareupdate', '--list']).stdout
    end

    def installed?
      ::File.exist?('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib')
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
