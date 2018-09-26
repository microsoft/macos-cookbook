title 'remote access'

control 'remote-control' do
  title 'naprivs value represents remote control for all users'
  desc 'verify that naprivs has the bitmask value -1073741569'

  describe command('/usr/bin/dscl . list /Users naprivs') do
    its('stdout') { should match 'vagrant   -2147483648' }
  end

  describe command('defaults read /Library/Preferences/com.apple.RemoteManagement ARD_AllLocalUsersPrivs') do
    its('stdout') { should match '1073742079' }
  end
end
