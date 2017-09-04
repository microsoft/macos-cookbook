module Xcode
  # Helper methods for recipes
  module Helper
    def xcode_installed?
      installed_xcodes = shell_out!('/usr/local/bin/xcversion installed').stdout.split(/\s+/).reject!.with_index { |_, i| i.even? } || []

      installed_xcode_versions = installed_xcodes.map do |xcode|
        path = xcode[1..-2]
        shell_out!("DEVELOPER_DIR=#{path} xcodebuild -version").stdout.split.last
      end

      installed_xcode_versions.include?(node['apex_automation']['xcode']['build_version'])
    end
  end
end

::Chef::Resource.send(:include, Xcode::Helper)
