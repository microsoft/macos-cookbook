require 'spec_helper'

describe 'macos::keep_awake' do
  context 'When all attributes are default, on macOS High Sierra 10.13' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      allow_any_instance_of(Chef::Resource).to receive(:running_in_a_vm?).and_return(false)
      allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(false)
      expect { chef_run }.to_not raise_error
    end
  end
end
