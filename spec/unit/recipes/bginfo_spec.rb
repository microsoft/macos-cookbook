require 'spec_helper'

describe 'macos::bginfo' do
  context 'BGInfo recipe downloads, installs, and runs BGInfo service' do
    before(:each) do
      stub_command('which git').and_return(true)
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.12')
      runner.converge(described_recipe)
    end

    it 'set the BGInfo owner to the system autoLoginUser' do
      expect(chef_run.node.normal['bginfo']['owner']).to eq({})
      expect(chef_run).to run_ruby_block('set BGInfo owner to autoLoginUser')
    end

    it 'installs homebrew dependencies' do
      expect(chef_run).to include_recipe('homebrew')
      expect(chef_run).to install_package('imagemagick')
      expect(chef_run).to install_package('ghostscript')
    end

    it 'clones the BGInfo repository' do
      expect(chef_run).to sync_git('/Users/Shared/BGInfo')
    end

    it 'sets permissions for BGInfo home folder and contents' do
      home = '/Users/Shared/BGInfo'
      chef_run.node.normal['bginfo']['owner'] = 'vagrant'
      expect(chef_run).to create_directory(home).with(owner: 'vagrant',
                                                      group: 'staff')
      bginfo_home_contents = %w(bginfo.command
                                macstorage.sh
                                final_bg.gif
                                storage.rb)
      bginfo_home_contents.each do |file|
        expect(chef_run).to create_file("#{home}/#{file}").with(owner: 'vagrant',
                                                                group: 'staff')
      end
    end

    it 'creates and enables a LaunchAgent for BGInfo' do
      expect(chef_run).to enable_launchd(
        'com.microsoft.bginfo'
      ).with(
        run_at_load: true,
        type: 'agent',
        start_calendar_interval: { 'Hour' => 0o5, 'Minute' => 0 }
      )
    end
  end
end
