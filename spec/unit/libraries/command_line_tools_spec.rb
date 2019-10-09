require 'spec_helper'
include MacOS

shared_context 'able to create on-demand installation sentinel' do
  before do
    allow(FileUtils).to receive(:touch).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end
end

shared_context 'on macOS Mojave' do
  before do
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:macos_version)
      .and_return('10.14')
  end
end

shared_context 'on macOS Catalina' do
  before do
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:macos_version)
      .and_return('10.15')
  end
end

shared_context 'with no CLT previously installed' do
  before  do
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:install_history_plist)
      .and_return('spec/unit/libraries/data/InstallHistory_without_CLT.plist')
  end
end

shared_context 'with CLT previously installed' do
  before  do
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:install_history_plist)
      .and_return('spec/unit/libraries/data/InstallHistory_with_CLT.plist')
  end
end

describe MacOS::CommandLineTools do
  context 'when there are several products for one Xcode version but several macOS versions' do
    include_context 'able to create on-demand installation sentinel'
    include_context 'on macOS Mojave'
    include_context 'with no CLT previously installed' 
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n",
                     "   * Command Line Tools (macOS Mojave version 10.14) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS Mojave version 10.14) for Xcode (10.0), 187321K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.4\n"])
    end
    it 'returns the latest product for that version of macOS' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS Mojave version 10.14) for Xcode-10.0'
    end
  end

  context 'when there are no products for the current macOS version' do
    include_context 'able to create on-demand installation sentinel'
    include_context 'on macOS Mojave'
    include_context 'with no CLT previously installed' 
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2\n",
                     "\tCommand Line Tools (macOS El Capitan version 10.11) for Xcode (8.2), 150374K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n"])
    end
    it 'returns the latest product for the most recent version of macOS' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0'
    end
  end

  context 'when provided an available list of software update products in Catalina' do
    include_context 'able to create on-demand installation sentinel'
    include_context 'on macOS Catalina'
    include_context 'with no CLT previously installed' 
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "* Label: Command Line Tools for Xcode-11.0\n",
                     "\tTitle: Command Line Tools for Xcode, Version: 11.0, Size: 224868K, Recommended: YES, \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools for Xcode-11.0'
    end
  end

  context 'when provided an available list of software update products in Catalina' do
    include_context 'able to create on-demand installation sentinel'
    include_context 'on macOS Catalina'
    include_context 'with CLT previously installed' 
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "* Label: Command Line Tools for Xcode-22.0\n",
                     "\tTitle: Command Line Tools for Xcode, Version: 22.0, Size: 224868K, Recommended: YES, \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools for Xcode-11.0'
      expect(clt.version).to_not eq 'Command Line Tools for Xcode-22.0'
    end 
  end
end

