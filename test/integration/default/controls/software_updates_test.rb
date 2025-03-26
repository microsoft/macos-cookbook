title 'software updates'

control 'updates-disabled' do
  title 'automatic check and download disabled'
  desc 'Verify that software updates do not download or install automatically'

  software_update_plist = '/Library/Preferences/com.apple.SoftwareUpdate.plist'
  app_store_plist = '/Library/Preferences/com.apple.commerce.plist'
  check = 'AutomaticCheckEnabled'
  download = 'AutomaticDownload'
  install_os = 'AutomaticallyInstallMacOSUpdates'
  install_critical = 'CriticalUpdateInstall'
  install_config_data = 'ConfigDataInstall'
  install_app_store = 'AutoUpdate'

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{check}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{download}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{install_os}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{install_critical}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{install_config_data}' #{software_update_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :#{install_app_store}' #{app_store_plist}") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{check}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{download}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{install_os}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{install_critical}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read-type #{software_update_plist} #{install_config_data}") do
  its('stdout') { should match('boolean') }
end

  describe command("/usr/bin/defaults read-type #{app_store_plist} #{install_app_store}") do
    its('stdout') { should match('boolean') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{check}") do
    its('stdout') { should match('0') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{download}") do
    its('stdout') { should match('0') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{install_os}") do
    its('stdout') { should match('0') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{install_critical}") do
    its('stdout') { should match('0') }
  end

  describe command("/usr/bin/defaults read #{software_update_plist} #{install_config_data}") do
  its('stdout') { should match('0') }
end

  describe command("/usr/bin/defaults read #{app_store_plist} #{install_app_store}") do
    its('stdout') { should match('0') }
  end

  describe command('/usr/sbin/softwareupdate --schedule') do
    its('stdout') { should match 'off' }
  end
end
