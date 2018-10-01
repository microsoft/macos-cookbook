require 'spec_helper'

describe 'macos::disable_software_updates' do
  context 'When all attributes are default, on macOS High Sierra 10.13' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      allow_any_instance_of(MacOS::SoftwareUpdates).to receive(:automatic_check_disabled?)
        .and_return(false)
      expect { chef_run }.to_not raise_error
    end
  end
end
