require 'spec_helper'

describe 'macos::spotlight' do
  step_into :spotlight

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
