require 'spec_helper'

describe 'macos::boxcutter' do
  context 'macOS High Sierra 10.13' do
    let(:node_attributes) do
      { platform: 'mac_os_x', version: '10.13' }
    end
    it_behaves_like 'a successful convergence'
  end
end
