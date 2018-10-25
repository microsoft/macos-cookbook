require 'spec_helper'
include MacOS::ARD

describe MacOS::ARD, '#ard_already_activated?' do
  context 'when remote management is already enabled' do
    before do
      allow(::File).to receive(:exist?)
        .with('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd')
        .and_return(true)
    end
    it 'returns true' do
      expect(ard_already_activated?).to be true
    end
  end
end

describe MacOS::ARD, '#ard_already_configured?' do
  context 'when remote management is already configured for the defaults' do
    before do
      allow_any_instance_of(ARD).to receive(:remote_management_plist)
        .and_return 'Dict { ARD_AllLocalUsersPrivs = 1073742079
                            allowInsecureDH = true
                            ARD_AllLocalUsers = true }'
    end
    it 'returns true' do
      expect(ard_already_configured?(['-allowAccessFor -allUsers', '-access -on', '-privs -all'])).to be true
    end
  end
end
