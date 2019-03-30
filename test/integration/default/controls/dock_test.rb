user_home = os_env('HOME').content

title 'dock'

control 'dock-appearance' do
  title 'how the dock looks'
  desc 'Verify changes are made to the dock by modifying the plist'

  describe command("/usr/libexec/PlistBuddy -c 'Print :orientation' #{user_home}/Library/Preferences/com.apple.dock.plist") do
    its('stdout') { should match 'left' }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :DisableAllAnimations' #{user_home}/Library/Preferences/com.apple.dock.plist") do
    its('stdout') { should match 'true' }
  end

  describe file("#{user_home}/Library/Preferences/com.apple.dock.plist") do
    its('owner') { should eq 'vagrant' }
    its('group') { should eq 'staff' }
  end
end
