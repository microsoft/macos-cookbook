include Chef::Mixin::ShellOut

module MacOS
  class CommandLineTools
    attr_reader :product

    def initialize
      @product = if available_command_line_tools.empty?
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
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
