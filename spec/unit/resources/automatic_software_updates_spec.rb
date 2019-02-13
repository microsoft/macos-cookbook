require 'spec_helper'

describe 'automatic_software_updates' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'enables automatic check and download' do
      check true
      download true
      os true
      app_store true
      critical true
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
