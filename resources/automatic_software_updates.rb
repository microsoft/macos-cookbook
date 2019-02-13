resource_name :automatic_software_updates

property :check, [TrueClass, FalseClass]

property :download, [TrueClass, FalseClass]

property :os, [TrueClass, FalseClass]

property :app_store, [TrueClass, FalseClass]

property :critical, [TrueClass, FalseClass]

action :set do
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'AutomaticCheckEnabled'
    value true
  end
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'AutomaticDownload'
    value true
  end
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'AutomaticallyInstallMacOSUpdates'
    value true
  end
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'CriticalUpdateInstall'
    value true
  end
  plist '/Library/Preferences/com.apple.commerce.plist' do
    entry 'AutoUpdate'
    value true
  end
end
