include Chef::Mixin::ShellOut

module MacOS
  class CommandLineTools
    attr_reader :product

    def initialize
      @product = available_products.lines
                                   .select { |s| s.include?('* Command') }
                                   .last.tr('*', '').strip
    end

    def available_products
      shell_out('softwareupdate -l').stdout
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
