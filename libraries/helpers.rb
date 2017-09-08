module PspdfkitCiMacos
  # Helper methods for recipes
  module Helper
    def xcode_installed?

      # [2] pry(main)> installed_xcodes = `xcversion installed`.split(/\s+/).reject!.with_index { |_, i| i.even? } || []
      # => ["(/Applications/Xcode.app)", "(/Users/erichanko/projects-local/Xcode-8.3.3.app)"]
      installed_xcodes = shell_out!('/usr/local/bin/xcversion installed').stdout.split(/\s+/).reject!.with_index { |_, i| i.even? } || []

      # [5] pry(main)> installed_xcode_versions = installed_xcodes.map do |xcode|
      #   [5] pry(main)*   path = xcode[1..-2]
      #   [5] pry(main)*   `DEVELOPER_DIR=#{path} xcodebuild -version`.split.last
      #   [5] pry(main)* end
      # => ["8E2002", "8E3004b"]

      installed_xcode_versions = installed_xcodes.map do |xcode|
        # Remove brackets by removing first and last character
        path = xcode[1..-2]
        shell_out!("DEVELOPER_DIR=#{path} xcodebuild -version").stdout.split.last
      end

      # Take the declared build version and check to see if it already exists in the list of
      # installed Xcode build versions
      installed_xcode_versions.include?(node['macos']['xcode']['build_version'])
    end
  end
end

::Chef::Resource.send(:include, PspdfkitCiMacos::Helper)
