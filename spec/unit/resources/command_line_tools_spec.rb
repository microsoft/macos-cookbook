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

    it { is_expected.to run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }
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

    it { is_expected.to_not run_execute('install Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0') }
  end
end
