include Chef::Mixin::ShellOut
require 'plist'

module MacOS
  class CommandLineTools
    attr_reader :version

    def initialize
      @version = if installed.empty?
                   latest_from_catalog
                 else
                   latest_installed
                 end
    end

    def installed
      packages = Plist.parse_xml(install_history_plist)
      packages.select { |package| package['displayName'].match? 'Command Line Tools' }
    end

    def latest_installed
      [installed.last['displayName'], installed.last['displayVersion']].join '-'
    end

    def latest_from_catalog
      if all_available.empty?
        Chef::Log.warn 'No Command Line Tools available from Software Update Catalog!'
      else
        catalog_recommendation_label.tr('*', '').gsub('Label: ', '').strip
      end
    end

    def catalog_recommendation_label
      if platform_specific.empty?
        Chef::Log.info "No Command Line Tools specific to #{macos_version} available from Software Update Catalog, selecting by maximum Xcode version."
        Chef::Log.info 'Command Line Tools version will be selected using maximum Xcode version.'
        recommend_version(all_available)
      else
        recommend_version(platform_specific)
      end
    end

    def recommend_version(software_update_package_list)
      versions = software_update_package_list.map { |product| Gem::Version.new xcode_version(product) }
      software_update_package_list.detect { |product| product.include? versions.max.version }
    end

    def all_available
      softwareupdate_list.select { |product_name| product_name.match /\*.{1,8}Command Line Tools/ }
    end

    def platform_specific
      all_available.select { |product_name| product_name.include? macos_version }
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
      shell_out(['/usr/bin/sw_vers', '-productVersion']).stdout.chomp[/1[01]\.\d+/]
    end

    def softwareupdate_list
      enable_install_on_demand
      shell_out(['softwareupdate', '--list']).stdout.lines
    end

    def install_history_plist
      File.open('/Library/Receipts/InstallHistory.plist', 'r')
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
