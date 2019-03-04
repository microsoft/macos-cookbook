resource_name :automatic_software_updates

property :check, [TrueClass, FalseClass]
property :download, [TrueClass, FalseClass]
property :install_os, [TrueClass, FalseClass]
property :install_app_store, [TrueClass, FalseClass]
property :install_critical, [TrueClass, FalseClass]

software_update_plist = '/Library/Preferences/com.apple.SoftwareUpdate.plist'
app_store_plist = '/Library/Preferences/com.apple.commerce.plist'

action :set do
  unless new_resource.check
    if new_resource.download
      raise "No other properties of this resource can be true if 'check' is false"
    end
  end

  unless new_resource.download
    if new_resource.install_os || new_resource.install_app_store
      raise "OS or App Store updates cannot be enabled if 'download' is false"
    end
  end

  plist 'entry for AutomaticCheckEnabled' do
    entry 'AutomaticCheckEnabled'
    value new_resource.check
    path software_update_plist
  end

  plist 'entry for AutomaticDownload' do
    entry 'AutomaticDownload'
    value new_resource.download
    path software_update_plist
  end

  plist 'entry for CriticalUpdateInstall' do
    entry 'CriticalUpdateInstall'
    value new_resource.install_critical
    path software_update_plist
  end

  plist 'entry for AutomaticallyInstallMacOSUpdates' do
    entry 'AutomaticallyInstallMacOSUpdates'
    value new_resource.install_os
    path software_update_plist
  end

  plist 'entry for AutoUpdate' do
    entry 'AutoUpdate'
    value new_resource.install_app_store
    path app_store_plist
  end
end
