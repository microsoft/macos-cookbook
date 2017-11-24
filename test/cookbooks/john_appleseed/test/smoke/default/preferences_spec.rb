control 'macOS user preferences' do
  desc 'they are set to the correct values'

  describe command("/usr/libexec/PlistBuddy -c 'Print :orientation' /Users/vagrant/Library/Preferences/com.apple.dock.plist") do
    its('stdout') { should match 'left' }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :AppleShowAllFiles' /Users/vagrant/Library/Preferences/com.apple.finder.plist") do
    its('stdout') { should match 'true' }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :DisableAllAnimations' /Users/vagrant/Library/Preferences/com.apple.dock.plist") do
    its('stdout') { should match 'true' }
  end
end
