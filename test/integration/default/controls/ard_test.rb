title 'remote access'

user_has_access  = 1 << 31
text_messages    = 1 << 0
control_observe  = 1 << 1
send_files       = 1 << 2
delete_files     = 1 << 3
generate_reports = 1 << 4
open_quit_apps   = 1 << 5
change_settings  = 1 << 6
restart_shutdown = 1 << 7
show_observe     = 1 << 30

all_privileges = text_messages | control_observe | send_files |
                 delete_files | generate_reports | open_quit_apps |
                 change_settings | restart_shutdown | show_observe

control 'remote-control' do
  title 'naprivs value represents remote control for all users'
  desc "verify that naprivs has the bitmask value #{all_privileges}"

  describe command('/usr/bin/dscl . list /Users naprivs') do
    its('stdout') { should match /#{user_has_access}/ }
  end

  describe command('defaults read /Library/Preferences/com.apple.RemoteManagement ARD_AllLocalUsersPrivs') do
    its('stdout') { should cmp all_privileges }
  end

  describe command('/usr/libexec/PlistBuddy -c Print /Library/Preferences/com.apple.RemoteManagement.plist') do
    its('stdout') { should match 'ARD_AllLocalUsers = true' }
  end
end
