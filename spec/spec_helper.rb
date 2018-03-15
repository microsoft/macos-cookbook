require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/macos_user'
require_relative '../libraries/machine_name'
require_relative '../libraries/metadata_util'
require_relative '../libraries/plist'
require_relative '../libraries/systemsetup'
require_relative '../libraries/xcode'
require_relative '../libraries/xcversion'
require_relative '../libraries/security_cmd'

RSpec.configure do |config|
  config.platform = 'mac_os_x'
  config.version = '10.13'
end

shared_context 'when running on bare metal' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['virtualization']['systems'] = { 'vbox' => 'host', 'parallels' => 'host' }
    end
  end

  before(:each) do
    allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(true)
    stub_command('which git').and_return('/usr/bin/git')
  end

  shared_examples 'setting metal-specific power preferences' do
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
  end
end

shared_context 'running in a parallels virtual machine' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['virtualization']['systems'] = { 'parallels' => 'guest' }
    end
  end

  before(:each) do
    allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(false)
    stub_command('which git').and_return('/usr/bin/git')
  end

  shared_examples 'not setting metal-specific power prefs' do
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
  end
end

shared_context 'running in a vmware fusion virtual machine' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['virtualization']['systems'] = {}
    end
  end

  before(:each) do
    allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(false)
    stub_command('which git').and_return('/usr/bin/git')
  end

  shared_examples 'not setting metal-specific power prefs' do
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
  end
end
