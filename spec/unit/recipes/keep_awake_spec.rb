require 'spec_helper'

include MacOS::SystemSetup

shared_context 'when running on bare metal' do
  shared_examples 'setting metal-specific power preferences' do
    before(:each) do
      allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(true)
      chef_run.node.normal['virtualization']['systems'] = { 'vbox' => 'host', 'parallels' => 'host' }
      stub_command('which git').and_return('/usr/bin/git')
    end

    it 'returns false' do
      expect(running_in_a_vm?).to be false
    end

    it 'sets wake on lan' do
      chef_run.converge(described_recipe)
      expect(chef_run).to set_system_preference('wake the computer when accessed using a network connection')
    end

    it 'disables power button sleep' do
      chef_run.converge(described_recipe)
      expect(chef_run).to set_system_preference('pressing power button does not sleep computer')
    end

    it 'sets restart after a power failure' do
      chef_run.converge(described_recipe)
      expect(chef_run).to set_system_preference('restart after a power failure')
    end

    it 'converges successfully on bare metal' do
      expect { chef_run }.to_not raise_error
    end
  end
end

shared_context 'running in a parallels virtual machine' do
  before(:each) do
    allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(false)
    chef_run.node.normal['virtualization']['systems'] = { 'parallels' => 'guest' }
    stub_command('which git').and_return('/usr/bin/git')
  end

  shared_examples 'not setting metal-specific power prefs' do
    it 'confirms we are in a vm' do
      expect(running_in_a_vm?).to be true
    end

    it 'does not set wake on lan' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('wake the computer when accessed using a network connection')
    end

    it 'skips disabling power button sleep' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('pressing power button does not sleep computer')
    end

    it 'does not set restart after a power failure' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('restart after a power failure')
    end

    it 'converges successfully in a vm' do
      expect { chef_run }.to_not raise_error
    end
  end
end

shared_context 'running in an undetermined virtualization system' do
  before(:each) do
    allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(false)
    chef_run.node.override['virtualization']['systems'] = {}
    stub_command('which git').and_return('/usr/bin/git')
  end

  shared_examples 'not setting metal-specific power prefs' do
    it 'assumes we are in a vm' do
      expect(running_in_a_vm?).to be true
    end

    it 'does not set wake on lan' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('wake the computer when accessed using a network connection')
    end

    it 'skips disabling power button sleep' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('pressing power button does not sleep computer')
    end

    it 'does not set restart after a power failure' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('restart after a power failure')
    end

    it 'converges successfully in a vm' do
      expect { chef_run }.to_not raise_error
    end
  end
end

describe 'macos::keep_awake' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  describe 'keep_awake in a parallels vm' do
    include_context 'running in a parallels virtual machine'
    it_behaves_like 'not setting metal-specific power prefs'
  end

  describe 'keep_awake in an undetermined virtualization system' do
    include_context 'running in an undetermined virtualization system'
    it_behaves_like 'not setting metal-specific power prefs'
  end

  describe 'keep_awake on bare metal' do
    include_context 'when running on bare metal'
    it_behaves_like 'setting metal-specific power preferences'
  end
end
