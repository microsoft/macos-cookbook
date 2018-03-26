title 'software updates'

control 'updates-disabled' do
  title 'automatic check and download disabled'
  desc 'Verify that software updates do not download or install automatically'

  software_update_plist = '/Library/Preferences/com.apple.SoftwareUpdate.plist'
  automatic_check_enabled = 'AutomaticCheckEnabled'
  automatic_download = 'AutomaticDownload'

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{automatic_check_enabled}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{automatic_download}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{automatic_download}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{automatic_check_enabled}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{automatic_download}") do
    its('stdout') { should match('0') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{automatic_check_enabled}") do
    its('stdout') { should match('0') }
  end

  describe command('/usr/sbin/softwareupdate --schedule') do
    its('stdout') { should match 'Automatic check is off' }
  end
end
