require 'spec_helper'

describe 'xcode' do
  step_into :xcode
  platform 'mac_os_x'

  default_attributes['macos']['apple_id']['user'] = 'developer@apple.com'
  default_attributes['macos']['apple_id']['password'] = 'apple_id_password'

  before(:each) do
    allow_any_instance_of(MacOS::DeveloperAccount).to receive(:authenticate_with_apple)
      .and_return(true)
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:macos_version)
      .and_return('10.13')
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
      .and_return(["Software Update Tool\n",
                   "\n", "Finding available software\n",
                   "Software Update found the following new or updated software:\n",
                   "   * Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2\n",
                   "\tCommand Line Tools (macOS El Capitan version 10.11) for Xcode (8.2), 150374K [recommended]\n",
                   "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                   "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n",
                   "   * Command Line Tools (macOS Mojave version 10.14) for Xcode-10.0\n",
                   "\tCommand Line Tools (macOS Mojave version 10.14) for Xcode (10.0), 187321K [recommended]\n",
                   "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.3\n",
                   "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.3), 187312K [recommended]\n",
                   "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.4\n",
                   "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.4), 187380K [recommended]\n"]
                 )
    allow(MacOS::XCVersion).to receive(:available_versions)
      .and_return(["10\n",
                   "10.1 beta 2\n",
                   "4.3 for Lion\n",
                   "4.3.1 for Lion\n",
                   "4.3.2 for Lion\n",
                   "4.3.3 for Lion\n",
                   "4.4\n",
                   "4.4.1\n",
                   "4.5\n",
                   "4.5.1\n",
                   "4.5.2\n",
                   "4.6\n",
                   "4.6.1\n",
                   "4.6.2\n",
                   "4.6.3\n",
                   "5\n",
                   "5.0.1\n",
                   "5.0.2\n",
                   "5.1\n",
                   "5.1.1\n",
                   "6.0.1\n",
                   "6.1\n",
                   "6.1.1\n",
                   "6.2\n",
                   "6.3\n",
                   "6.3.1\n",
                   "6.3.2\n",
                   "6.4\n",
                   "7\n",
                   "7.0.1\n",
                   "7.1\n",
                   "7.1.1\n",
                   "7.2\n",
                   "7.2.1\n",
                   "7.3\n",
                   "7.3.1\n",
                   "8\n",
                   "8.1\n",
                   "8.2\n",
                   "8.2.1\n",
                   "8.3\n",
                   "8.3.1\n",
                   "8.3.2\n",
                   "8.3.3\n",
                   "9\n",
                   "9.0.1\n",
                   "9.1\n",
                   "9.2\n",
                   "9.3\n",
                   "9.3.1\n",
                   "9.4\n",
                   "9.4.1\n"]
                 )
    allow(File).to receive(:exist?).and_call_original
    allow(FileUtils).to receive(:touch).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end

  context 'with no Xcodes installed, and no CLT installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:installed?)
        .and_return(false)
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0'
    end

    it { is_expected.to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with no Xcodes installed, and with CLT installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:installed?)
        .and_return(true)
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0'
    end

    it { is_expected.not_to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with requested Xcode installed, and with CLT installed' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '10.0' => '/Applications/Xcode.app' }])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:installed?)
        .and_return(true)
      stub_command('test -L /Applications/Xcode.app').and_return(false)
    end

    recipe do
      xcode '10.0'
    end

    it { is_expected.not_to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }

    it { is_expected.not_to run_execute('install Xcode 10') }
    it { is_expected.not_to delete_link('/Applications/Xcode.app') }

    it { is_expected.not_to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end

  context 'with requested Xcode installed at a different path, and with CLT present' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '10.0' => '/Applications/Some_Weird_Path.app' }])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:installed?)
        .and_return(true)
      stub_command('test -L /Applications/Xcode.app').and_return(false)
    end

    recipe do
      xcode '10.0' do
        path '/Applications/Chef_Managed_Xcode.app'
      end
    end

    it { is_expected.not_to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }

    it { is_expected.not_to run_execute('install Xcode 10') }
    it { is_expected.not_to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Some_Weird_Path.app to /Applications/Chef_Managed_Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Chef_Managed_Xcode.app') }
  end

  context 'with requested Xcode version not installed, and something at the requested path' do
    before(:each) do
      allow(MacOS::XCVersion).to receive(:installed_xcodes)
        .and_return([{ '9.3' => '/Applications/Xcode.app' }])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:installed?)
        .and_return(false)
      stub_command('test -L /Applications/Xcode.app').and_return(true)
    end

    recipe do
      xcode '10.0' do
        path '/Applications/Xcode.app'
      end
    end

    it { is_expected.to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }

    it { is_expected.to run_execute('install Xcode 10') }
    it { is_expected.to delete_link('/Applications/Xcode.app') }

    it { is_expected.to run_execute('move /Applications/Xcode-10.app to /Applications/Xcode.app') }
    it { is_expected.to run_execute('switch active Xcode to /Applications/Xcode.app') }
  end
end
