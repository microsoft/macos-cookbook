require 'spec_helper'
include MacOS

describe MacOS::CommandLineTools do
  context 'when provided an available list of software update products in Mojave' do
    before do
      allow(FileUtils).to receive(:touch).and_return(true)
      allow(FileUtils).to receive(:chown).and_return(true)
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:macos_version)
        .and_return('10.14')
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n",
                     "   * Command Line Tools (macOS Mojave version 10.14) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS Mojave version 10.14) for Xcode (10.0), 187321K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.3\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.3), 187312K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.4\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.4), 187380K [recommended]\n"]
                   )
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS Mojave version 10.14) for Xcode-10.0'
    end
  end

  context 'when provided an available list of software update products in High Sierra' do
    before do
      allow(FileUtils).to receive(:touch).and_return(true)
      allow(FileUtils).to receive(:chown).and_return(true)
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:macos_version)
        .and_return('10.13')
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.3\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.3), 187312K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.4\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.4), 187380K [recommended]\n"]
                   )
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0'
    end
  end
end
