require 'spec_helper'

describe 'command_line_tools' do
  step_into :command_line_tools
  platform 'mac_os_x'

  before(:each) do
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
    allow(File).to receive(:exist?).and_call_original
    allow(FileUtils).to receive(:touch).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end

  context 'with no CLT installed' do
    before(:each) do
      allow(File).to receive(:exist?).with('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib').and_return(false)
    end

    recipe do
      command_line_tools 'horse'
    end

    it { is_expected.to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }
  end

  context 'with CLT installed' do
    before(:each) do
      allow(File).to receive(:exist?).with('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib').and_return(true)
    end

    recipe do
      command_line_tools 'no_description'
    end

    it { is_expected.to_not run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }
  end
end
