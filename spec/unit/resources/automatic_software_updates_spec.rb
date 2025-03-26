require 'spec_helper'
software_update_plist = '/Library/Preferences/com.apple.SoftwareUpdate.plist'
app_store_plist = '/Library/Preferences/com.apple.commerce.plist'
describe 'automatic software updates entirely disabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'disable all updates' do
      check false
      download false
      install_os false
      install_app_store false
      install_critical false
      install_config_data false
    end
  end

  it {
    is_expected.to set_plist('entry for AutomaticCheckEnabled')
      .with(entry: 'AutomaticCheckEnabled',
            value: false,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for AutomaticDownload')
      .with(entry: 'AutomaticDownload',
            value: false,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for AutomaticallyInstallMacOSUpdates')
      .with(entry: 'AutomaticallyInstallMacOSUpdates',
            value: false,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for CriticalUpdateInstall')
      .with(entry: 'CriticalUpdateInstall',
            value: false,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for ConfigDataInstall')
      .with(entry: 'ConfigDataInstall',
            value: false,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for AutoUpdate')
      .with(entry: 'AutoUpdate',
            value: false,
            path: app_store_plist)
  }
end

describe 'automatic software updates entirely enabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'enable automatic check, download, and install of all updates' do
      check true
      download true
      install_os true
      install_app_store true
      install_critical true
      install_config_data true
    end
  end

  it {
    is_expected.to set_plist('entry for AutomaticCheckEnabled')
      .with(entry: 'AutomaticCheckEnabled',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for AutomaticDownload')
      .with(entry: 'AutomaticDownload',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for AutomaticallyInstallMacOSUpdates')
      .with(entry: 'AutomaticallyInstallMacOSUpdates',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for CriticalUpdateInstall')
      .with(entry: 'CriticalUpdateInstall',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for ConfigDataInstall')
      .with(entry: 'ConfigDataInstall',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for AutoUpdate')
      .with(entry: 'AutoUpdate',
            value: true,
            path: app_store_plist)
  }
end

describe 'automatic software update checking disabled but other properties are enabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'download and install everything but no new updates' do
      check false
      download true
      install_os true
      install_app_store true
      install_critical true
      install_config_data true
    end
  end

  it 'raises an error' do
    expect { subject }.to raise_error(RuntimeError, /No other properties of this resource can be true if 'check' is false/)
  end
end

describe 'automatic software update downloading is disabled but installing non-critical updates is enabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'install OS and App Store updates' do
      check true
      download false
      install_os true
    end
  end

  it 'raises an error' do
    expect { subject }.to raise_error(RuntimeError, /OS or App Store updates cannot be enabled if 'download' is false/)
  end
end

describe 'automatic software update downloading is disabled but installing non-critical updates is enabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'install OS and App Store updates' do
      check true
      download false
      install_app_store true
    end
  end

  it 'raises an error' do
    expect { subject }.to raise_error(RuntimeError, /OS or App Store updates cannot be enabled if 'download' is false/)
  end
end

describe 'automatic software update downloading is disabled but installing critical updates is enabled' do
  step_into :automatic_software_updates
  platform 'mac_os_x'

  recipe do
    automatic_software_updates 'only install critical updates' do
      check true
      download false
      install_critical true
      install_config_data true
    end
  end

  it {
    is_expected.to set_plist('entry for AutomaticCheckEnabled')
      .with(entry: 'AutomaticCheckEnabled',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for CriticalUpdateInstall')
      .with(entry: 'CriticalUpdateInstall',
            value: true,
            path: software_update_plist)
  }

  it {
    is_expected.to set_plist('entry for ConfigDataInstall')
      .with(entry: 'ConfigDataInstall',
            value: true,
            path: software_update_plist)
  }
end
