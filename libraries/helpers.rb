module PspdfkitCiMacos
  # Helper methods for recipes
  module Helper
    def xcode_installed?
      # > xcversion installed
      # 7.3 (/Applications/Xcode.app)
      #
      # irb(main):001:0> installed_xcodes = `xcversion installed`.split(/\s+/).reject!.with_index { |_, i| i.even? } || []
      # => ["(/Applications/Xcode.app)"]
      installed_xcodes = shell_out!('/usr/local/bin/xcversion installed').stdout.split(/\s+/).reject!.with_index { |_, i| i.even? } || []

      installed_xcode_versions = installed_xcodes.map do |xcode|
        # Remove brackets by removing first and last character
        path = xcode[1..-2]
        shell_out!("DEVELOPER_DIR=#{path} xcodebuild -version").stdout.split.last
      end

      installed_xcode_versions.include?(node['apex_automation']['xcode']['build_version'])
    end
  end
end

::Chef::Resource.send(:include, PspdfkitCiMacos::Helper)
