include Chef::Mixin::ShellOut

module MacOS
  class CommandLineTools
    attr_reader :version

    def initialize
      install_sentinel = '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
      FileUtils.touch install_sentinel
      FileUtils.chown 'root', 'wheel', install_sentinel

      @version = if available.empty?
                   'Unavailable from Software Update Catalog'
                 else
                   latest.tr('*', '').strip
                 end
    end

    def latest
      versions = platform_specific.map { |product| Gem::Version.new xcode_version(product) }
      platform_specific.detect { |product| product.include? versions.max.version }
    end

    def platform_specific
      available.select { |product_name| product_name.include? macos_version }
    end

    def available
      softwareupdate_list.select { |product_name| product_name.include?('* Command Line Tools') }
    end

    def xcode_version(product)
      product.match(/Xcode-(?<version>\d+\.\d+)/)['version']
    end

    def macos_version
      shell_out(['/usr/bin/sw_vers', '-productVersion']).stdout.chomp[/10\.\d+/]
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
