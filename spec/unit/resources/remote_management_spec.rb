require 'spec_helper'

describe 'remote_management' do
  step_into :remote_management
  platform 'mac_os_x'

  context 'with remote management not already enabled' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
        .and_return(false)
    end

    recipe do
      remote_management 'enabled' do
        action :enable
      end
    end

    it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate') }
    it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -access -on -privs -all') }
  end

  context 'with remote management not already enabled' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
        .and_return(false)
    end

    recipe do
      remote_management 'disabled' do
        action :disable
      end
    end

    it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate') }
    it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -stop') }
  end

  context 'with remote management already enabled and configured' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
        .and_return(true)
      allow(RemoteManagement).to receive(:plist)
        .and_return 'Dict { ARD_AllLocalUsersPrivs = 1073742079
                            allowInsecureDH = true
                            ARD_AllLocalUsers = true }'
    end

    recipe do
      remote_management 'enabled' do
        action :enable
      end
    end

    it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate') }
    it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -access -on -privs -all') }
  end

  context 'with remote management already enabled and configured' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?)
        .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
        .and_return(true)
      allow_any_instance_of(RemoteManagement).to receive(:plist)
        .and_return 'Dict { ARD_AllLocalUsersPrivs = 1073742079
                                allowInsecureDH = true
                                ARD_AllLocalUsers = true }'
    end

    recipe do
      remote_management 'disabled' do
        action :disable
      end
    end

    it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate') }
    it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -stop') }
  end
end
