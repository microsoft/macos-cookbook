require 'spec_helper'

describe 'macos::default' do
  context 'When all attributes are default, on macOS 10.12' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
