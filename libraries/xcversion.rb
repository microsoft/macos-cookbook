include Chef::Mixin::ShellOut

module MacOS
  module XCVersion
    class << self
      def xcversion_path
        Chef::Util::PathHelper.join(Chef::Config.embedded_dir, 'bin', 'xcversion')
      end

      def xcversion(command)
        [xcversion_path, command].join(' ')
      end

      def update
        xcversion 'update'
      end

      def list_simulators
        xcversion 'simulators'
      end

      def install_simulator(simulator)
        xcversion "simulators --install='#{simulator.version}'"
      end

      def list_installed_xcodes
        xcversion 'installed'
      end

      def list_available_xcodes
        xcversion 'list'
      end

      def download_url_option(xcode)
        options = ''

        unless xcode.download_url.empty?
          options = "--url='#{xcode.download_url}'"
        end

        options
      end

      def install_xcode(xcode)
        xcversion "install '#{xcode.version}' #{download_url_option(xcode)}".strip
      end

      def installed_xcodes
        lines = shell_out(XCVersion.list_installed_xcodes).stdout.lines
        lines.map { |line| { line.split.first => line.split.last.delete('()') } }
      end

      def available_versions
        lines = shell_out!(XCVersion.list_available_xcodes).stdout.lines
        lines.reject! { |line| line.start_with?(/\D/) }
        lines.map { |line| line.chomp('(installed)').strip }
      end
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
