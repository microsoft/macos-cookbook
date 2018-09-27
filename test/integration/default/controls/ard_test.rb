title 'remote access'

control 'remote-control' do
  title 'naprivs value represents remote control for all users'
  desc 'Verify that naprivs has the magic value to indicate all privileges'

  # user_has_access  = 0b1 << 31
  # text_messages    = 0b1 << 0
  # control_observe  = 0b1 << 1
  # send_files       = 0b1 << 2
  # delete_files     = 0b1 << 3
  # generate_reports = 0b1 << 4
  # open_quit_apps   = 0b1 << 5
  # change_settings  = 0b1 << 6
  # restart_shutDown = 0b1 << 7
  # observe_only     = 0b1 << 8
  # show_observe     = 0b1 << 30

  describe command('/usr/libexec/PlistBuddy -c Print /Library/Preferences/com.apple.RemoteManagement.plist') do
    its('stdout') { should match 'ARD_AllLocalUsers = true' }
    its('stdout') { should match 'ARD_AllLocalUsersPrivs = 1073742079' }
  end
end
