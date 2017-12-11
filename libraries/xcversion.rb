module MacOS
  module XCVersion
    class << self
      def command
        '/opt/chef/embedded/bin/xcversion'.freeze
      end

      def update
        command + ' update'
      end

      def list_simulators
        command + ' simulators'
      end

      def install_simulator(version)
        command + " simulators --install='#{version}'"
      end

      def list_xcodes
        command + ' list'
      end

      def install_xcode(version)
        command + " install '#{apple_pseudosemantic_version(version)}'"
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
