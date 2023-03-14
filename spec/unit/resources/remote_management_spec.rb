require_relative '../../spec_helper'

shared_context 'remote management enabled' do
  before { allow(RemoteManagement).to receive(:activated?).and_return true }
end

shared_context 'remote management disabled' do
  before { allow(RemoteManagement).to receive(:activated?).and_return false }
end

shared_context 'users current mask is -2147483648 (no privileges)' do
  let(:current_mask) { RemoteManagement::Privileges::Mask.new(mask: -2147483648) }

  before { allow(RemoteManagement).to receive(:current_users_configured?).and_return true }
  before { allow(RemoteManagement).to receive(:current_users_have_identical_masks?).and_return true }
  before { allow(RemoteManagement).to receive(:current_mask).and_return(current_mask) }
end

shared_context 'users current mask is -1073741569 (all privileges)' do
  let(:current_mask) { RemoteManagement::Privileges::Mask.new(mask: -1073741569) }

  before { allow(RemoteManagement).to receive(:current_users_configured?).and_return true }
  before { allow(RemoteManagement).to receive(:current_users_have_identical_masks?).and_return true }
  before { allow(RemoteManagement).to receive(:current_mask).and_return(current_mask) }
end

shared_context 'no current computer info' do
  before { allow(RemoteManagement).to receive(:current_computer_info).and_return [] }
end

shared_context 'SIP is disabled' do
  before { allow(RemoteManagement::TCC::SIP).to receive(:disabled?).and_return true }
end

shared_context 'correct tccstate' do
  before { allow(RemoteManagement::TCC::State).to receive(:enabled?).and_return true }
end

shared_context 'incorrect tccstate' do
  before { allow(RemoteManagement::TCC::State).to receive(:enabled?).and_return false }
end

shared_context 'correct TCC database privileges' do
  before do
    allow(RemoteManagement::TCC::DB).to receive(:correct_privileges?).and_return true
  end
end

shared_context 'incorrect TCC database privileges' do
  before do
    allow(RemoteManagement::TCC::DB).to receive(:correct_privileges?).and_return false
    allow(RemoteManagement::TCC::DB).to receive(:screensharing_client_authorized_for_post_event_service?).and_return false
    allow(RemoteManagement::TCC::DB).to receive(:screensharing_client_authorized_for_screencapture_service?).and_return false
  end
end

shared_examples 'activating the ARD agent' do
  it {
    is_expected.to run_execute('activate the Remote Management service and restart the agent')
      .with(command: ['/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-activate', '-restart', '-agent'])
  }
end

shared_examples 'not activating the ARD agent' do
  it { is_expected.to_not run_execute('activate the Remote Management service and restart the agent') }
end

shared_examples 'configuring the ARD agent for all users' do
  it {
    is_expected.to run_execute('set privileges for all users')
      .with(command: ['/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-configure', '-allowAccessFor', '-allUsers', '-access', '-on', '-privs', '-all'])
  }
end

shared_examples 'not configuring the ARD agent for all users' do
  it { is_expected.to_not run_execute('set privileges for all users') }
end

shared_examples 'configuring the ARD agent for specified users' do
  it {
    is_expected.to run_execute('set up Remote Management to only grant access to users with privileges')
      .with(command: ['/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-configure', '-allowAccessFor', '-specifiedUsers'])
  }
  it {
    is_expected.to run_execute('set privileges for bilbo')
      .with(command: ['/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-configure', '-access', '-on', '-privs', '-all', '-users', 'bilbo'])
  }
end

shared_examples 'not configuring the ARD agent for specified users' do
  it { is_expected.to_not run_execute('set up Remote Management to only grant access to users with privileges') }
  it { is_expected.to_not run_execute('set privileges for bilbo') }
end

shared_examples 'restarting the TCC daemon' do
  it {
    is_expected.to run_execute('restart the TCC daemon')
      .with(command: 'sudo pkill -9 tccd')
  }
end

shared_examples 'not restarting the TCC daemon' do
  it { is_expected.to_not run_execute('restart the TCC daemon') }
end

shared_examples 'deactivating and stopping the ARD agent' do
  it {
    is_expected.to run_execute('stop the Remote Management service and deactivate it so it will not start after the next restart')
      .with(command: ['/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-deactivate', '-stop'])
  }
end

shared_examples 'not deactivating or stopping the ARD agent' do
  it { is_expected.to_not run_execute('stop the Remote Management service and deactivate it so it will not start after the next restart') }
end

shared_examples 'setting the computer info' do
  it {
    is_expected.to run_execute('set computer info field 1')
      .with(command: ['/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-configure', '-computerinfo', '-set1', '-1', 'Arkenstone'])
  }
end

shared_examples 'not setting the computer info' do
  it { is_expected.to_not run_execute('set computer info 1') }
end

describe 'enabling for all users when currently disabled' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'correct TCC database privileges'
  include_context 'incorrect tccstate'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent, giving all users all privileges' do
      users 'all'
      privileges 'all'
      computer_info []
      action :enable
    end
  end

  it_behaves_like 'configuring the ARD agent for all users'
  it_behaves_like 'restarting the TCC daemon'
  it_behaves_like 'activating the ARD agent'

  it_behaves_like 'not configuring the ARD agent for specified users'
  it_behaves_like 'not setting the computer info'
end

describe 'enabling for specified users when currently disabled' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'correct TCC database privileges'
  include_context 'correct tccstate'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges 'all'
      computer_info []
      action :enable
    end
  end

  it_behaves_like 'configuring the ARD agent for specified users'
  it_behaves_like 'not restarting the TCC daemon'
  it_behaves_like 'activating the ARD agent'

  it_behaves_like 'not configuring the ARD agent for all users'
  it_behaves_like 'not setting the computer info'
end

describe 'enabling for specified users when currently enabled and current privileges are different than the desired privileges' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management enabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'correct TCC database privileges'
  include_context 'incorrect tccstate'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges 'all'
      computer_info []
      action :enable
    end
  end

  it_behaves_like 'configuring the ARD agent for specified users'
  it_behaves_like 'restarting the TCC daemon'
  it_behaves_like 'activating the ARD agent'

  it_behaves_like 'not configuring the ARD agent for all users'
  it_behaves_like 'not setting the computer info'
end

describe 'enabling when the current computer info differs from the desired computer info' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management enabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'correct TCC database privileges'
  include_context 'incorrect tccstate'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges 'all'
      computer_info ['Arkenstone']
      action :enable
    end
  end

  it_behaves_like 'setting the computer info'
end

describe 'enabling for specified users when currently enabled and current privileges are the same as the desired privileges' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management enabled'
  include_context 'users current mask is -1073741569 (all privileges)'
  include_context 'no current computer info'
  include_context 'correct TCC database privileges'
  include_context 'incorrect tccstate'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges 'all'
      computer_info []
      action :enable
    end
  end

  it_behaves_like 'not configuring the ARD agent for specified users'
  it_behaves_like 'not configuring the ARD agent for all users'
  it_behaves_like 'not restarting the TCC daemon'
  it_behaves_like 'not activating the ARD agent'
  it_behaves_like 'not setting the computer info'
end

describe 'trying to enable when TCC does not have the correct privileges' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'incorrect TCC database privileges'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges 'all'
      computer_info []
      action :enable
    end
  end

  it { expect { subject }.to raise_error(RemoteManagement::Exceptions::TCCError) }
end

describe 'trying to enable with invalid privileges' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'incorrect TCC database privileges'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges 'smaug'
      computer_info []
      action :enable
    end
  end

  it { expect { subject }.to raise_error(Chef::Exceptions::ValidationFailed) }
end

describe 'trying to enable with invalid privileges' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'incorrect TCC database privileges'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges ['nazgûl', 'smèagol']
      computer_info []
      action :enable
    end
  end

  it { expect { subject }.to raise_error(Chef::Exceptions::ValidationFailed) }
end

describe 'enable with abnormally formatted privileges' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'no current computer info'
  include_context 'correct TCC database privileges'
  include_context 'incorrect tccstate'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'enable the ARD agent' do
      users 'bilbo'
      privileges ['DeleteFiles', 'text messages', 'SEND__FILES', 'restart-shut-down']
      computer_info []
      action :enable
    end
  end

  it { expect { subject }.to_not raise_error }
end

describe 'disabling when currently disabled' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management disabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'disable the ARD agent' do
      action :disable
    end
  end

  it_behaves_like 'not deactivating or stopping the ARD agent'
end

describe 'disabling when currently enabled' do
  platform 'mac_os_x', '12'
  step_into :remote_management

  include_context 'remote management enabled'
  include_context 'users current mask is -2147483648 (no privileges)'
  include_context 'SIP is disabled'

  recipe do
    remote_management 'disable the ARD agent' do
      action :disable
    end
  end

  it_behaves_like 'deactivating and stopping the ARD agent'
end
