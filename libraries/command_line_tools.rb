include Chef::Mixin::ShellOut

module MacOS
  class CommandLineTools
    attr_reader :version

    def initialize
      if history_entry.empty?
        install_sentinel = '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
        FileUtils.touch install_sentinel
        FileUtils.chown 'root', 'wheel', install_sentinel
        @version = if available.empty?
                     Chef::Log.warn 'No Command Line Tools available from Software Update Catalog!'
                   else
                     latest.tr('*', '').gsub('Label: ', '').strip
                   end
      else
        @version = history_version
      end
    end

    def latest
      if platform_specific.empty?
        Chef::Log.info "No Command Line Tools specific to #{macos_version} available from Software Update Catalog, selecting by maximum Xcode version."
        versions = available.map { |product| Gem::Version.new xcode_version(product) }
        available.detect { |product| product.include? versions.max.version }
      else
        versions = platform_specific.map { |product| Gem::Version.new xcode_version(product) }
        platform_specific.detect { |product| product.include? versions.max.version }
      end
    end

    def softwareupdate_history
      shell_out(['softwareupdate', '--history']).stdout.lines
    end

    def history_entry
      softwareupdate_history.select { |line| line.include?('Command Line Tools') }
    end

    def history_version
      history_entry.first.split('  ').reject(&:empty?).map(&:strip).first(2).join '-'
    end

    def platform_specific
      available.select { |product_name| product_name.include? macos_version }
    end

    def available
      softwareupdate_list.select { |product_name| product_name.match /\*.{1,8}Command Line Tools/ }
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
