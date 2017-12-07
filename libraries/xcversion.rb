module MacOS
  module XCVersion
    class << self
      def command
        '/opt/chef/embedded/bin/xcversion'.freeze
      end

      def version(semantic_version)
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
