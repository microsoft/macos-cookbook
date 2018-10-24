include Chef::Mixin::ShellOut

module MacOS
  module ARD
    def ard_already_activated?
      ::File.exist?('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
    end

    def ard_already_configured?(configure_options)
      return false unless configure_options == ['-allowAccessFor -allUsers', '-access -on', '-privs -all']
      remote_management_plist.include?('ARD_AllLocalUsers = true') && remote_management_plist.include?('1073742079')
    end

    def remote_management_plist
      shell_out('/usr/libexec/PlistBuddy -c Print /Library/Preferences/com.apple.RemoteManagement.plist').stdout
    end
  end
end

Chef::Recipe.include(MacOS::ARD)
Chef::Resource.include(MacOS::ARD)
