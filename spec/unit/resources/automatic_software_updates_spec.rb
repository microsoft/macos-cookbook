require 'spec_helper'

describe 'automatic_software_updates_entirely_disabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'disables automatic check and download' do
      check false
      download false
      install_os false
      install_app_store false
      install_critical false
    end
  end

  it {
    is_expected.to set_plist('entry for AutomaticCheckEnabled')
      .with(entry: 'AutomaticCheckEnabled',
            value: false,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for AutomaticDownload')
      .with(entry: 'AutomaticDownload',
            value: false,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for AutomaticallyInstallMacOSUpdates')
      .with(entry: 'AutomaticallyInstallMacOSUpdates',
            value: false,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for CriticalUpdateInstall')
      .with(entry: 'CriticalUpdateInstall',
            value: false,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for AutoUpdate')
      .with(entry: 'AutoUpdate',
            value: false,
            path: '/Library/Preferences/com.apple.commerce.plist')
  }
end

describe 'automatic_software_updates_entirely_enabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'disables automatic check and download' do
      check true
      download true
      install_os true
      install_app_store true
      install_critical true
    end
  end

  it {
    is_expected.to set_plist('entry for AutomaticCheckEnabled')
      .with(entry: 'AutomaticCheckEnabled',
            value: true,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for AutomaticDownload')
      .with(entry: 'AutomaticDownload',
            value: true,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for AutomaticallyInstallMacOSUpdates')
      .with(entry: 'AutomaticallyInstallMacOSUpdates',
            value: true,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for CriticalUpdateInstall')
      .with(entry: 'CriticalUpdateInstall',
            value: true,
            path: '/Library/Preferences/com.apple.SoftwareUpdate.plist')
  }

  it {
    is_expected.to set_plist('entry for AutoUpdate')
      .with(entry: 'AutoUpdate',
            value: true,
            path: '/Library/Preferences/com.apple.commerce.plist')
  }
end
