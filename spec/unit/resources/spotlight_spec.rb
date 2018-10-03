require 'spec_helper'

describe 'macos::spotlight' do
  step_into :spotlight

  stubs_for_provider('spotlight[test]') do |provider|
    allow(provider).to receive_shell_out('/usr/bin/mdutil', '-s', '/')
  end

  context 'Spotlight resource converges successfully' do
    platform 'mac_os_x', 10.13

    recipe do
      spotlight 'test' do
        indexed false
        searchable false
        volume '/'
      end
    end

    it { is_expected.to run_execute('turn Spotlight indexing off for /') }
  end
end
