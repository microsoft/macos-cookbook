require 'spec_helper'

describe 'automatic_software_updates_false' do
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
  it { is_expected.to set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist').with(entry: 'AutomaticCheckEnabled', value: false).and set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist').with(entry: 'AutomaticDownload', value: false) }
  # it { is_expected.to set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist').with(entry: 'AutomaticDownload', value: false) }
  # it { is_expected.to set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist').with(entry: 'AutomaticallyInstallMacOSUpdates', value: false) }
  # it { is_expected.to set_plist('/Library/Preferences/com.apple.SoftwareUpdate.plist').with(entry: 'CriticalUpdateInstall', value: false) }
  # it { is_expected.to set_plist('/Library/Preferences/com.apple.commerce.plist').with(entry: 'AutoUpdate', value: false) }
end
