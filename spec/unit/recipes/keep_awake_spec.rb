require 'spec_helper'

describe 'macos::keep_awake' do
  context 'When all attributes are default, on macOS High Sierra 10.13' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully on bare metal' do
      allow_any_instance_of(Chef::Resource).to receive(:running_in_a_vm?).and_return(false)
      allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(false)
      expect { chef_run }.to_not raise_error
    end

    it 'converges successfully in a vm' do
      allow_any_instance_of(Chef::Resource).to receive(:running_in_a_vm?).and_return(true)
      allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(true)
      expect { chef_run }.to_not raise_error
    end
  end

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
