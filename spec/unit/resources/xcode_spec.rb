require 'spec_helper'

describe 'xcode' do
  step_into :xcode
  platform 'mac_os_x'

  default_attributes['macos']['apple_id']['user'] = 'developer@apple.com'
  default_attributes['macos']['apple_id']['password'] = 'apple_id_password'

  before(:each) do
    allow_any_instance_of(MacOS::DeveloperAccount).to receive(:authenticate_with_apple)
      .and_return(true)
    allow(MacOS::XCVersion).to receive(:available_versions)
      .and_return(['4.3 for Lion',
                   '4.3.1 for Lion',
                   '4.3.2 for Lion',
                   '4.3.3 for Lion',
                   '4.4',
                   '4.4.1',
                   '4.5',
                   '4.5.1',
                   '4.5.2',
                   '4.6',
                   '4.6.1',
                   '4.6.2',
                   '4.6.3',
                   '5',
                   '5.0.1',
                   '5.0.2',
                   '5.1',
                   '5.1.1',
                   '6.0.1',
                   '6.1',
                   '6.1.1',
                   '6.2',
                   '6.3',
                   '6.3.1',
                   '6.3.2',
                   '6.4',
                   '7',
                   '7.0.1',
                   '7.1',
                   '7.1.1',
                   '7.2',
                   '7.2.1',
                   '7.3',
                   '7.3.1',
                   '8',
                   '8.1',
                   '8.2',
                   '8.2.1',
                   '8.3',
                   '8.3.1',
                   '8.3.2',
                   '8.3.3',
                   '9',
                   '9.0.1',
                   '9.1',
                   '9.2',
                   '9.3',
                   '9.4.1',
                   '9.4.2 beta 2',
                   '9.4.2',
                   '10 beta 1',
                   '10 Release Candidate',
                   '10',
                   '10.1',
                   '10.2.1',
                   '10.2',
                   '10.3',
                   '11',
                   '11.1',
                   '11.2',
                   '11.2.1',
                   '11.3 beta',
                   '11.3',
                   '11.3.1',
                   '11.4 beta',
                   '11.4',
                   '11.4 beta 3',
                   '11.4 beta 2',
                   '11.4.1',
                   '11.5 beta',
                   '11.5',
                   '11.5 Release Candidate',
                   '11.5 beta 2',
                   '11.6 beta',
                   '12 beta 4',
                   '12 for macOS Universal Apps beta',
                   '12 beta 3',
                   '12 beta 2',
                   '12 for macOS Universal Apps beta 2',
                   '12 beta'])
    allow(File).to receive(:exist?).and_call_original
    allow(FileUtils).to receive(:touch).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end

  context 'with no Xcodes installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0' do
        version '10.0'
      end
    end

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and a beta Xcode requested' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode 'betamax!' do
        version '11.6'
      end
    end

    it { is_expected.to run_execute('install Xcode 11.6 beta') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it {
      is_expected.to run_execute('move /Applications/Xcode-11.6.beta.app to /Applications/Xcode.app').with(command: ['mv',
                                                                                                                     '/Applications/Xcode-11.6.beta.app', '/Applications/Xcode.app'])
    }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and the URL property defined' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.1' do
        download_url 'https://apple.com'
        version '0.0'
      end
    end

    it { is_expected.to run_execute('install Xcode 0.0') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-0.0.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and a modern Xcode requested on an older platform' do
    automatic_attributes['platform_version'] = '10.12'
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
    end

    recipe do
      xcode '10.1'
    end

    it 'raises an error' do
      expect { subject }.to raise_error(RuntimeError, /Xcode 10\.1 not supported on 10.12/)
    end
  end

  context 'with no Xcodes installed, and a vintage Xcode requested on an older platform' do
    automatic_attributes['platform_version'] = '10.12'
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '9.2'
    end

    it 'does not raise an error' do
      expect { subject }.to_not raise_error
    end
  end

  context 'with requested Xcode installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '10.0' => '/Applications/Xcode.app' }])
      stub_command('test -L /Applications/Xcode.app').and_return(false)
    end

    recipe do
      xcode '10.0'
    end

    it { is_expected.not_to run_execute('install Xcode 10') }
    it { is_expected.not_to delete_link('/Applications/Xcode.app') }

    it { is_expected.not_to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with requested Xcode installed at a different path' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '10.0' => '/Applications/Some_Weird_Path.app' }])
      stub_command('test -L /Applications/Xcode.app').and_return(false)
    end

    recipe do
      xcode '10.0' do
        path '/Applications/Chef_Managed_Xcode.app'
      end
    end

    it { is_expected.not_to run_execute('install Xcode 10') }
    it { is_expected.not_to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Some_Weird_Path.app to /Applications/Chef_Managed_Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Chef_Managed_Xcode.app') }
  end

  context 'with requested Xcode version not installed, and something at the requested path' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '9.3' => '/Applications/Xcode.app' }])
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0' do
        path '/Applications/Xcode.app'
      end
    end

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end
end
