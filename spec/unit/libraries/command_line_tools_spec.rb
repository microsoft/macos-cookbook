require 'spec_helper'
include MacOS

describe MacOS::CommandLineTools do
  shared_context 'able to create on-demand installation sentinel'
  shared_context 'on macOS Mojave'
  context 'when provided an available list of software update products in Mojave, and no previous installation' do

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
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.4), 187380K [recommended]\n"])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_history)
        .and_return(["Display Name                                       Version    Date                  \n",
                     "------------                                       -------    ----                  \n",
                     "XProtectPlistConfigData                            2106       10/01/2019, 13:25:12  \n",
                     "Gatekeeper Configuration Data                      181        09/30/2019, 13:36:29  \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS Mojave version 10.14) for Xcode-10.0'
    end
  end

  shared_context 'able to create on-demand installation sentinel'
  shared_context 'on macOS Mojave'
  context 'when provided an incomplete list of software update products in Mojave, and no previous installation' do
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2\n",
                     "\tCommand Line Tools (macOS El Capitan version 10.11) for Xcode (8.2), 150374K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.3\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.3), 187312K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.4\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.4), 187380K [recommended]\n"])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_history)
        .and_return(["Display Name                                       Version    Date                  \n",
                     "------------                                       -------    ----                  \n",
                     "XProtectPlistConfigData                            2106       10/01/2019, 13:25:12  \n",
                     "Gatekeeper Configuration Data                      181        09/30/2019, 13:36:29  \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0'
    end
  end

  shared_context 'able to create on-demand installation sentinel'
  shared_context 'on macOS High Sierra'
  context 'when provided an available list of software update products in High Sierra, and no previous installation' do
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "   * Command Line Tools (macOS El Capitan version 10.11) for Xcode-8.2\n",
                     "\tCommand Line Tools (macOS El Capitan version 10.11) for Xcode (8.2), 150374K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (10.0), 190520K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.3\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.3), 187312K [recommended]\n",
                     "   * Command Line Tools (macOS High Sierra version 10.13) for Xcode-9.4\n",
                     "\tCommand Line Tools (macOS High Sierra version 10.13) for Xcode (9.4), 187380K [recommended]\n"])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_history)
        .and_return(["Display Name                                       Version    Date                  \n",
                     "------------                                       -------    ----                  \n",
                     "XProtectPlistConfigData                            2106       10/01/2019, 13:25:12  \n",
                     "Gatekeeper Configuration Data                      181        09/30/2019, 13:36:29  \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools (macOS High Sierra version 10.13) for Xcode-10.0'
    end
  end

  shared_context 'able to create on-demand installation sentinel'
  shared_context 'on macOS Catalina'
  context 'when provided an available list of software update products in Catalina, and no previous installation' do
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "* Label: Command Line Tools for Xcode-11.0\n",
                     "\tTitle: Command Line Tools for Xcode, Version: 11.0, Size: 224868K, Recommended: YES, \n"])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_history)
        .and_return(["Display Name                                       Version    Date                  \n",
                     "------------                                       -------    ----                  \n",
                     "XProtectPlistConfigData                            2106       10/01/2019, 13:25:12  \n",
                     "Gatekeeper Configuration Data                      181        09/30/2019, 13:36:29  \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools for Xcode-11.0'
    end
  end

  shared_context 'able to create on-demand installation sentinel'
  shared_context 'on macOS Catalina'
  context 'when provided an available list of software update products in Catalina, and version 11 already installed' do
    before do
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_list)
        .and_return(["Software Update Tool\n",
                     "\n", "Finding available software\n",
                     "Software Update found the following new or updated software:\n",
                     "* Label: Command Line Tools for Xcode-22.0\n",
                     "\tTitle: Command Line Tools for Xcode, Version: 22.0, Size: 224868K, Recommended: YES, \n"])
      allow_any_instance_of(MacOS::CommandLineTools).to receive(:softwareupdate_history)
        .and_return(["Display Name                                       Version    Date                  \n",
                     "------------                                       -------    ----                  \n",
                     "XProtectPlistConfigData                            2106       10/01/2019, 13:25:12  \n",
                     "Command Line Tools for Xcode                       11.0       10/01/2019, 13:25:10  \n",
                     "MRTConfigData                                      1.49       09/30/2019, 13:36:29  \n",
                     "Gatekeeper Configuration Data                      181        09/30/2019, 13:36:29  \n"])
    end
    it 'returns the latest recommended Command Line Tools product' do
      clt = MacOS::CommandLineTools.new
      expect(clt.version).to eq 'Command Line Tools for Xcode-11.0'
      expect(clt.version).to_not eq 'Command Line Tools for Xcode-22.0'
    end
  end
end


shared_context 'able to create on-demand installation sentinel' do
  before do
    allow(FileUtils).to receive(:touch).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end
end

shared_context 'on macOS High Sierra' do
  before do
    allow_any_instance_of(MacOS::CommandLineTools).to receive(:macos_version)
      .and_return('10.13')
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
