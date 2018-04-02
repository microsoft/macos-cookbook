include Chef::Mixin::ShellOut

module MacOS
  module XCVersion
    class << self
      def xcversion
        '/opt/chef/embedded/bin/xcversion '.freeze
      end

      def update
        xcversion + 'update'
      end

      def list_simulators
        xcversion + 'simulators'
      end

      def install_simulator(version)
        xcversion + "simulators --install='#{version}'"
      end

      def list_xcodes
        shell_out(xcversion + 'list').stdout
      end

      def install_xcode(semantic_version)
        apple_version = apple_pseudosemantic_version(semantic_version)
        xcodes = list_xcodes.lines
        xcode_name = xcodes.find { |v| v.match?(apple_version) }.strip
        xcversion + "install '#{xcode_name}'"
      end

      def installed_xcodes
        xcversion + 'installed'
      end

      def apple_pseudosemantic_version(semantic_version)
        split_version = semantic_version.split('.')
        if split_version.length == 2 && split_version.last == '0'
          split_version.first
        else
          semantic_version
        end
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
