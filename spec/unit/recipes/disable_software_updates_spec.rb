require 'spec_helper'

describe 'macos::disable_software_updates' do
  context 'When all attributes are default, on macOS High Sierra 10.13' do
    before do
      allow_any_instance_of(MacOS::SoftwareUpdates).to receive(:automatic_check_disabled?)
        .and_return(false)
      stubs_for_resource('execute[disable software updates using commandline utility]') do |resource|
        allow(resource).to receive_shell_out('/usr/sbin/softwareupdate', '--schedule')
      end
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
