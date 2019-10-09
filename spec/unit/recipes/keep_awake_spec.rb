require 'spec_helper'

include MacOS::System

shared_context 'running on bare metal Mac Mini' do
  before(:each) do
    chef_run.node.automatic['virtualization']['systems'] = { 'vbox' => 'host', 'Parallels' => 'host' }
    chef_run.node.automatic['hardware']['machine_model'] = 'Macmini7,1'
  end

  shared_examples 'including metal-specific power preferences' do
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

shared_context 'when running on bare metal MacBook Pro' do
  before(:each) do
    chef_run.node.automatic['virtualization']['systems'] = { 'vbox' => 'host', 'Parallels' => 'host' }
    chef_run.node.automatic['hardware']['machine_model'] = 'MacBookPro14,3'
  end

  shared_examples 'including metal-specific power preferences for portables' do
    it 'sets wake on lan' do
      chef_run.converge(described_recipe)
      expect(chef_run).to set_system_preference('wake the computer when accessed using a network connection')
    end

    it 'does not set restart after a power failure' do
      chef_run.converge(described_recipe)
      expect(chef_run).to_not set_system_preference('restart after a power failure')
    end

    it 'converges successfully on bare metal' do
      expect { chef_run }.to_not raise_error
    end
  end
end

shared_context 'running in a Parallels virtual machine' do
  before(:each) do
    chef_run.node.automatic['virtualization']['systems'] = { 'Parallels' => 'guest' }
    chef_run.node.automatic['hardware']['machine_model'] = 'Parallels13,1'
  end

  shared_examples 'ignoring metal-specific power preferences' do
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
    chef_run.node.automatic['virtualization']['systems'] = {}
    chef_run.node.automatic['hardware']['machine_model'] = ''
  end

  shared_examples 'ignoring metal-specific power preferences' do
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

  describe 'keep_awake in a Parallels VM' do
    include_context 'running in a Parallels virtual machine'
    it_behaves_like 'ignoring metal-specific power preferences'
  end

  describe 'keep_awake in an undetermined virtualization system' do
    include_context 'running in an undetermined virtualization system'
    it_behaves_like 'ignoring metal-specific power preferences'
  end

  describe 'keep_awake on bare metal' do
    include_context 'running on bare metal Mac Mini'
    it_behaves_like 'including metal-specific power preferences'
  end

  describe 'keep_awake on portable bare metal' do
    include_context 'when running on bare metal MacBook Pro'
    it_behaves_like 'including metal-specific power preferences for portables'
  end
end
