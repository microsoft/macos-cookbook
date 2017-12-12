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
        xcversion + 'list'
      end

      def install_xcode(version)
        xcversion + "install '#{apple_pseudosemantic_version(version)}'"
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
