resource_name :automatic_software_updates

property :check, [TrueClass, FalseClass]

property :download, [TrueClass, FalseClass]

property :install_os, [TrueClass, FalseClass]

property :install_app_store, [TrueClass, FalseClass]

property :install_critical, [TrueClass, FalseClass]

action :set do
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'AutomaticCheckEnabled'
    value new_resource.check
  end
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'AutomaticDownload'
    value new_resource.download
  end
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'AutomaticallyInstallMacOSUpdates'
    value new_resource.install_os
  end
  plist '/Library/Preferences/com.apple.SoftwareUpdate.plist' do
    entry 'CriticalUpdateInstall'
    value new_resource.install_critical
  end
  plist '/Library/Preferences/com.apple.commerce.plist' do
    entry 'AutoUpdate'
    value new_resource.install_app_store
  end
end
