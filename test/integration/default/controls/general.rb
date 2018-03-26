user_home = os_env('HOME').content

title 'general'

control 'show-all-files' do
  title 'enable visibility of invisble files and folders'
  desc 'Verify changes to the finder plist show hidden files using PlistBuddy'

  finder_plist = "#{user_home}/Library/Preferences/com.apple.finder.plist"
  describe command("/usr/libexec/PlistBuddy -c 'Print :AppleShowAllFiles' #{finder_plist}") do
    its('stdout') { should match 'true' }
  end
end
