resource_name :automatic_software_updates

property :check, [TrueClass, FalseClass]

property :download, [TrueClass, FalseClass]

property :install_os, [TrueClass, FalseClass]

property :install_app_store, [TrueClass, FalseClass]

property :install_critical, [TrueClass, FalseClass]

path_to_software_update_plist = "/Library/Preferences/com.apple.SoftwareUpdate.plist"

action :set do

  plist 'entry for AutomaticCheckEnabled' do
    path path_to_software_update_plist
    entry 'AutomaticCheckEnabled'
    value new_resource.check
  end

  plist 'entry for AutomaticDownload' do
    path path_to_software_update_plist
    entry 'AutomaticDownload'
    value new_resource.download
  end

  plist 'entry for CriticalUpdateInstall' do
    path path_to_software_update_plist
    entry 'CriticalUpdateInstall'
    value new_resource.install_critical
  end

  plist 'entry for AutomaticallyInstallMacOSUpdates' do
    path path_to_software_update_plist
    entry 'AutomaticallyInstallMacOSUpdates'
    value new_resource.install_os
  end

  plist 'entry for AutoUpdate' do
    path '/Library/Preferences/com.apple.commerce.plist'
    entry 'AutoUpdate'
    value new_resource.install_app_store
  end
end
