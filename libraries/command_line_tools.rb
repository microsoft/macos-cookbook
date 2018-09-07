include Chef::Mixin::ShellOut

module MacOS
  class CommandLineTools
    attr_reader :version

    def initialize
      install_sentinel = '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
      FileUtils.touch install_sentinel
      FileUtils.chown 'root', 'wheel', install_sentinel

      @version = if available_command_line_tools.empty?
                   'Unavailable from Software Update Catalog'
                 else
                   available_command_line_tools.last.tr('*', '').strip
                 end
    end

    def available_command_line_tools
      softwareupdate_list.select { |product_name| product_name.include?('* Command Line Tools') }
    end

    def softwareupdate_list
      shell_out(['softwareupdate', '--list']).stdout.lines
    end

    def installed?
      ::File.exist?('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib')
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
