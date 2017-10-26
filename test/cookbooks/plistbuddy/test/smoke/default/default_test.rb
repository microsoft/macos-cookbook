describe command("/usr/libexec/PlistBuddy -c 'Print :showMissionControlGestureEnabled' /Users/vagrant/Library/Preferences/com.apple.dock.plist") do
  its('stdout') { should be 'true' }
end

describe command("/usr/libexec/PlistBuddy -c 'Print :AppleShowAllFiles' /Users/vagrant/Library/Preferences/com.apple.finder.plist") do
  its('stdout') { should be 'true' }
end

