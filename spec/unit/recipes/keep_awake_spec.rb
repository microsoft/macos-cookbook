require 'spec_helper'

describe 'macos::keep_awake' do
  context 'When all attributes are default, on macOS 10.12' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'mac_os_x', version: '10.12')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
