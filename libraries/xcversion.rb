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

      def install_simulator(simulator)
        xcversion + "simulators --install='#{simulator.version}'"
      end

      def list_xcodes
        xcversion + 'list'
      end

      def install_xcode(xcode)
        xcversion + "install '#{xcode.version}'"
      end

      def installed_xcodes
        lines = shell_out(xcversion + 'installed').stdout.lines
        lines.map { |line| { line.split.first => line.split.last.delete('()') } }
      end

      def available_versions
        shell_out!(XCVersion.list_xcodes).stdout.lines
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
