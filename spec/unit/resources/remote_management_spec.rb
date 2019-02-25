require 'spec_helper'

shared_context 'with remote management enabled' do
  step_into :remote_management
  platform 'mac_os_x'

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?)
      .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
      .and_return(true)
    allow(RemoteManagement).to receive(:plist_content)
      .and_return 'Dict { ARD_AllLocalUsersPrivs = 1073742079
                          ARD_AllLocalUsers = true }'
  end
end

shared_context 'with remote management disabled' do
  step_into :remote_management
  platform 'mac_os_x'

  before do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?)
      .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
      .and_return(false)
    allow(RemoteManagement).to receive(:plist_content)
      .and_return ''
  end
end

shared_examples 'kickstart activating and configuring the ARD agent' do
  it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate') }
  it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -access -on -privs -all') }
end

shared_examples 'kickstart deactivating and stopping the ARD agent' do
  it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate') }
  it { is_expected.to run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -stop') }
end

shared_examples 'kickstart not activating or configuring the ARD agent' do
  it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate') }
  it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -access -on -privs -all') }
end

shared_examples 'kickstart not deactivating or stopping the ARD agent' do
  it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate') }
  it { is_expected.to_not run_execute('/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -stop') }
end

describe 'enabling when already disabled' do
  include_context 'with remote management disabled'

  recipe do
    remote_management 'enabled' do
      action :enable
    end
  end

  it_behaves_like 'kickstart activating and configuring the ARD agent'
  it_behaves_like 'kickstart not deactivating or stopping the ARD agent'
end

describe 'enabling when already enabled' do
  include_context 'with remote management enabled'

  recipe do
    remote_management 'enabled' do
      action :enable
    end
  end

  it_behaves_like 'kickstart not activating or configuring the ARD agent'
  it_behaves_like 'kickstart not deactivating or stopping the ARD agent'
end

describe 'disabling when already disabled' do
  include_context 'with remote management disabled'

  recipe do
    remote_management 'disabled' do
      action :disable
    end
  end

  it_behaves_like 'kickstart not activating or configuring the ARD agent'
  it_behaves_like 'kickstart not deactivating or stopping the ARD agent'
end

describe 'disabling when already enabled' do
  include_context 'with remote management enabled'

  recipe do
    remote_management 'disabled' do
      action :disable
    end
  end

  it_behaves_like 'kickstart not activating or configuring the ARD agent'
  it_behaves_like 'kickstart deactivating and stopping the ARD agent'
end
