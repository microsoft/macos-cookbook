require 'spec_helper'
include MacOS

describe MacOS::CommandLineTools do
  context 'when provided an available list of software update products' do
    before do
      allow(FileUtils).to receive(:touch).and_return(true)
      allow(FileUtils).to receive(:chown).and_return(true)
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2\n",
                     "\tCommand Line Tools (macOS El Capitan version 10.11) for Xcode (8.2), 150374K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.2\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.2), 177376K [recommended]\n"]
                   )
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.2'
    end
  end
end
