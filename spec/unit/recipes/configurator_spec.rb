require 'spec_helper'

describe 'macos::configurator' do
  context 'Configurator recipe converges successfully' do
    before(:each) do
      stub_data_bag_item('credentials', 'apple_id').and_return(
        apple_id: 'developer@apple.com',
        password: 'apple_id_password'
      )
      stub_command('which git').and_return('/usr/local/bin/git')
      stub_command('/usr/local/bin/mas account').and_return('developer@apple.com')
    end

    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
