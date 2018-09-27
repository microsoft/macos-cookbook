title 'remote access'

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

all_privileges = text_messages | control_observe | send_files |
                 delete_files | generate_reports | open_quit_apps |
                 change_settings | restart_shutdown | show_observe

control 'remote-control' do
  title 'ensure that remote access and control will function'
  desc "ensure that the Remote Management plist grants local users access, that
        all privileges are granted based on the mask #{all_privileges}, and that
        remote control is enabled"

  describe command('/usr/libexec/PlistBuddy -c Print /Library/Preferences/com.apple.RemoteManagement.plist') do
    its('stdout') { should match 'ARD_AllLocalUsers = true' }
    its('stdout') { should match /#{all_privileges}/ }
  end

  describe file('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd') do
    it { should exist }
    its('content') { should match 'enabled' }
  end
end
