require 'spec_helper'

describe 'command_line_tools' do
  step_into :command_line_tools
  platform 'mac_os_x'

  before do
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:version)
      .and_return('Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0')
    allow(File).to receive(:exist?).and_call_original
  end

  context 'without libxcrun present' do
    before do
      allow(File).to receive(:exist?).with('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib').and_return(false)
    end

    recipe do
      command_line_tools 'horse' do
        action :install
      end
    end

    it { is_expected.to create_file('create demand file') }
    it { expect(chef_run.file('create demand file')).to notify('execute[install command line tools]').to(:run).immediately }
    it { is_expected.to delete_file('delete demand file') }
  end


  context 'with libxcrun present' do
    before do
      allow(File).to receive(:exist?).with('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib').and_return(true)
    end

    recipe do
      command_line_tools 'horse' do
        action :install
      end
    end

    it { is_expected.to_not create_file('create demand file') }
    it { is_expected.to_not run_execute('install command line tools') }
  end
end

describe 'command_line_tools' do
  step_into :command_line_tools
  platform 'mac_os_x'

  context 'with a different version of command line tools than currently installed available' do
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "* Label: Command Line Tools for Xcode-22.0\n",
                     "\tTitle: Command Line Tools for Xcode, Version: 22.0, Size: 224868K, Recommended: YES, \n"])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:install_history_plist)
        .and_return('spec/unit/libraries/data/InstallHistory_with_CLT.plist')
    end

    recipe do
      command_line_tools 'always latest' do
        action :upgrade
      end
    end

    it { is_expected.to create_file('create demand file') }
    it {
      is_expected.to run_execute('upgrade Command Line Tools for Xcode-11.0')
        .with(command: ['softwareupdate', '--install', 'Command Line Tools for Xcode-22.0'])
    }
    it { is_expected.to delete_file('delete demand file') }
  end
end
