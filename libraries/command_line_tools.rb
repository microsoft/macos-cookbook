include Chef::Mixin::ShellOut
require 'plist'

module MacOS
  class CommandLineTools
    attr_reader :version

    def initialize
      if installed.empty?
        enable_install_on_demand
        @version = lastest_from_catalog
      else
        @version = latest_installed
      end
    end

    def installed
      install_history = File.open('/Library/Receipts/InstallHistory.plist', 'r')
      packages = Plist.parse_xml(install_history)
      packages.select { |package| package['displayName'].match? 'Command Line Tools' }
    ends

    def latest_installed
      [installed.last['displayName'], installed.last['displayVersion']].join '-'
    end

    def latest_from_catalog
      if available.empty?
        Chef::Log.warn 'No Command Line Tools available from Software Update Catalog!'
      else
        catalog_recommendation_label.tr('*', '').gsub('Label: ', '').strip
      end
    end

    def catalog_recommendation_label
      if platform_specific.empty?
        Chef::Log.info "No Command Line Tools specific to #{macos_version} available from Software Update Catalog, selecting by maximum Xcode version."
        versions = available.map { |product| Gem::Version.new xcode_version(product) }
        available.detect { |product| product.include? versions.max.version }
      else
        versions = platform_specific.map { |product| Gem::Version.new xcode_version(product) }
        platform_specific.detect { |product| product.include? versions.max.version }
      end
    end

    def available
      softwareupdate_list.select { |product_name| product_name.match /\*.{1,8}Command Line Tools/ }
    end

    def platform_specific
      available.select { |product_name| product_name.include? macos_version }
    end

    def enable_install_on_demand
      install_sentinel = '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
      FileUtils.touch install_sentinel
      FileUtils.chown 'root', 'wheel', install_sentinel
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
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
