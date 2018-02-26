require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/macos_user'
require_relative '../libraries/metadata_util'
require_relative '../libraries/plist'
require_relative '../libraries/systemsetup'
require_relative '../libraries/xcode'
require_relative '../libraries/xcversion'

RSpec.configure do |config|
  config.alias_example_group_to :describe, type: :default_recipe
  config.platform = 'mac_os_x'
  config.version = '10.13'
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end

shared_context 'converged default recipe', type: :default_recipe do
  before(:each) do
    allow_any_instance_of(Chef::Resource).to receive(:running_in_a_vm?).and_return(true)
    allow_any_instance_of(Chef::Resource).to receive(:power_button_model?).and_return(true)
    stub_command('which sudo').and_return('/usr/bin/sudo')
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(node_attributes) do |node|
    end.converge(described_recipe)
  end

  shared_examples 'a successful convergence' do
    it 'does not raise an exception' do
      expect { chef_run }.to_not raise_error
    end
  end
end
