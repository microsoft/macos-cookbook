include Chef::Mixin::ShellOut

module MacOS
  class RemoteManagement
    class << self
      def activated?
        ::File.exist? '/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd'
      end

      def configured_for_all_users_and_privileges?
        RemoteManagement.plist_content.include?('ARD_AllLocalUsers = true') &&
          RemoteManagement.plist_content.include?(full_privileges)
      end

      def plist_content
        shell_out('/usr/libexec/PlistBuddy -c Print /Library/Preferences/com.apple.RemoteManagement.plist').stdout
      end

      def full_privileges
        text_messages    = 1 << 0
        control_observe  = 1 << 1
        send_files       = 1 << 2
        delete_files     = 1 << 3
        generate_reports = 1 << 4
        open_quit_apps   = 1 << 5
        change_settings  = 1 << 6
        restart_shutdown = 1 << 7
        show_observe     = 1 << 30

        (text_messages | control_observe | send_files |
          delete_files | generate_reports | open_quit_apps |
          change_settings | restart_shutdown | show_observe).to_s
      end
    end
  end
end

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
