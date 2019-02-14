require 'spec_helper'

describe 'automatic_software_updates' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'enables automatic check and download' do
      check true
      download true
      install_os true
      install_app_store true
      install_critical true
    end
  end

  it {
    is_expected.to set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist')
      .with(entry: 'AutomaticCheckEnabled', value: true)
      .with(entry: 'AutomaticDownload', value: true)
      .with(entry: 'AutomaticallyInstallMacOSUpdates', value: true)
      .with(entry: 'CriticalUpdateInstall', value: true)
    is_expected.to set_plist('/Library/Preferences/com.apple.commerce.plist')
      .with(entry: 'AutoUpdate', value: true)
  }
end

require 'spec_helper'

describe 'automatic_software_updates' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'enables automatic check and download' do
      check false
      download false
      install_os false
      install_app_store false
      install_critical false
    end
  end

  it {
    is_expected.to set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist')
      .with(entry: 'AutomaticCheckEnabled', value: false)
      .with(entry: 'AutomaticDownload', value: false)
      .with(entry: 'AutomaticallyInstallMacOSUpdates', value: false)
      .with(entry: 'CriticalUpdateInstall', value: false)
    is_expected.to set_plist('/Library/Preferences/com.apple.commerce.plist')
      .with(entry: 'AutoUpdate', value: false)
  }
end
