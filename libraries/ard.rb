include Chef::Mixin::ShellOut

module MacOS
  module ARD
    def ard_already_activated?
      ::File.exist?('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
    end

    def ard_already_configured?(configure_options)
      return false unless configure_options == ['-allowAccessFor -allUsers', '-access -on', '-privs -all']
      remote_management_plist.include?('ARD_AllLocalUsers = true') && remote_management_plist.include?(all_privileges)
    end

    def remote_management_plist
      shell_out('/usr/libexec/PlistBuddy -c Print /Library/Preferences/com.apple.RemoteManagement.plist').stdout
    end

    def all_privileges
      # user_has_access  = 1 << 31
      text_messages    = 1 << 0
      control_observe  = 1 << 1
      send_files       = 1 << 2
      delete_files     = 1 << 3
      generate_reports = 1 << 4
      open_quit_apps   = 1 << 5
      change_settings  = 1 << 6
      restart_shutdown = 1 << 7
      # observe_only     = 1 << 8
      show_observe     = 1 << 30

      (text_messages | control_observe | send_files |
        delete_files | generate_reports | open_quit_apps |
        change_settings | restart_shutdown | show_observe).to_s
    end
  end
end

Chef::Recipe.include(MacOS::ARD)
Chef::Resource.include(MacOS::ARD)
