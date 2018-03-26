require 'spec_helper'
include MacOS

describe MacOS::CommandLineTools do
  context 'when provided an available list of software update products' do
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:available_products)
        .and_return(<<~SOFTWAREUPDATE_LIST
                    Software Update Tool
                    Finding available software
                    Software Update found the following new or updated software:
                       * Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2
                    \tCommand Line Tools (macOS El Capitan version 10.11) for Xcode (8.2), 150374K [recommended]
                       * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.2
                    \tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.2), 177376K [recommended]
                    SOFTWAREUPDATE_LIST
                   )
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.product).to eq 'Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.2'
    end
  end
end
