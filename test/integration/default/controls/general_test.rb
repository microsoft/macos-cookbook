user_home = os_env('HOME').content

title 'general'

control 'show-all-files' do
  title 'enable visibility of invisble files and folders'
  desc 'Verify changes to the finder plist show hidden files using PlistBuddy'

  finder_plist = "#{user_home}/Library/Preferences/com.apple.finder.plist"
  describe command("/usr/libexec/PlistBuddy -c 'Print :AppleShowAllFiles' #{finder_plist}") do
    its('stdout') { should match 'true' }
  end

  describe file(finder_plist) do
    its('owner') { should eq 'vagrant' }
    its('group') { should eq 'staff' }
    its('mode') { should cmp '0600' }
  end
end