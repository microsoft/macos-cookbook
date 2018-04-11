require 'spec_helper'
include MacOS

describe MacOS::Xcode do
  context 'when initialized with developer credentials and Xcode betas available' do
    before do
      allow_any_instance_of(MacOS::Xcode).to receive(:authenticate_with_apple)
        .and_return(true)
      allow_any_instance_of(MacOS::Xcode).to receive(:find_apple_id)
        .and_return('apple_id': 'apple_id', 'password': 'password')
      allow_any_instance_of(MacOS::Xcode).to receive(:available_versions_list)
        .and_return(["4.3 for Lion\n",
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
                     "9.4 beta\n",
                     "10 GM seed\n"]
                   )
    end
    it 'returns the name of Xcode 10 GM when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('10.0')
      expect(xcode.version).to eq '10 GM seed'
    end
    it 'returns the name of Xcode 9.4 beta when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.4')
      expect(xcode.version).to eq '9.4 beta'
    end
    it 'returns the name of Xcode 9.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.3')
      expect(xcode.version).to eq '9.3'
    end
    it 'returns the name of Xcode 9 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.0')
      expect(xcode.version).to eq '9'
    end
    it 'returns the name of Xcode 8.3.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('8.3.3')
      expect(xcode.version).to eq '8.3.3'
    end
  end
end

describe MacOS::Xcode::Simulator do
  context 'when provided an available list of simulators' do
    before do
      allow_any_instance_of(MacOS::Xcode::Simulator).to receive(:available_versions)
        .and_return(<<-XCVERSION_OUTPUT
                    Xcode 9.2 (/Applications/Xcode-9.2.app)
                    iOS 8.1 Simulator (not installed)
                    iOS 8.2 Simulator (not installed)
                    iOS 8.3 Simulator (not installed)
                    iOS 8.4 Simulator (not installed)
                    iOS 9.0 Simulator (not installed)
                    iOS 9.1 Simulator (not installed)
                    iOS 9.2 Simulator (not installed)
                    iOS 9.3 Simulator (not installed)
                    iOS 10.0 Simulator (not installed)
                    iOS 10.1 Simulator (not installed)
                    tvOS 9.0 Simulator (not installed)
                    tvOS 9.1 Simulator (not installed)
                    tvOS 9.2 Simulator (not installed)
                    tvOS 10.0 Simulator (not installed)
                    watchOS 2.0 Simulator (not installed)
                    watchOS 2.1 Simulator (not installed)
                    watchOS 2.2 Simulator (not installed)
                    tvOS 10.1 Simulator (not installed)
                    iOS 10.2 Simulator (not installed)
                    watchOS 3.1 Simulator (not installed)
                    iOS 10.3.1 Simulator (not installed)
                    watchOS 3.2 Simulator (not installed)
                    tvOS 10.2 Simulator (not installed)
                    iOS 11.0 Simulator (not installed)
                    watchOS 4.0 Simulator (not installed)
                    tvOS 11.0 Simulator (not installed)
                    tvOS 11.1 Simulator (not installed)
                    watchOS 4.1 Simulator (not installed)
                    iOS 11.1 Simulator (not installed)
                    XCVERSION_OUTPUT
                   )
    end
    it 'returns the latest semantic version of iOS 11' do
      simulator = MacOS::Xcode::Simulator.new('11')
      expect(simulator.version).to eq 'iOS 11.1'
    end
    it 'returns the latest semantic version of iOS 10' do
      simulator = MacOS::Xcode::Simulator.new('10')
      expect(simulator.version).to eq 'iOS 10.3.1'
    end
    it 'returns the latest semantic version of iOS 9' do
      simulator = MacOS::Xcode::Simulator.new('9')
      expect(simulator.version).to eq 'iOS 9.3'
    end

    context 'when provided a list of device SDKs included with Xcode' do
      before do
        allow_any_instance_of(MacOS::Xcode::Simulator).to receive(:show_sdks)
          .and_return(<<-XCODEBUILD_OUTPUT
                    iOS SDKs:
                            iOS 11.2                      	-sdk iphoneos11.2

                    iOS Simulator SDKs:
                            Simulator - iOS 11.2          	-sdk iphonesimulator11.2

                    macOS SDKs:
                            macOS 10.13                   	-sdk macosx10.13

                    tvOS SDKs:
                            tvOS 11.2                     	-sdk appletvos11.2

                    tvOS Simulator SDKs:
                            Simulator - tvOS 11.2         	-sdk appletvsimulator11.2

                    watchOS SDKs:
                            watchOS 4.2                   	-sdk watchos4.2

                    watchOS Simulator SDKs:
                            Simulator - watchOS 4.2       	-sdk watchsimulator4.2
                    XCODEBUILD_OUTPUT
                     )
      end
      it 'determines that iOS 11 is included with this Xcode' do
        simulator = MacOS::Xcode::Simulator.new('11')
        expect(simulator.included_with_xcode?).to be true
      end
      it 'determines that iOS 10 is not included with this Xcode' do
        simulator = MacOS::Xcode::Simulator.new('10')
        expect(simulator.included_with_xcode?).to be false
      end
    end
  end
end

describe MacOS::Xcode::Version do
  context 'when initalized with a new major release of Xcode' do
    it 'recognizes a major release' do
      xcode = MacOS::Xcode::Version.new('9')
      expect(xcode.major_release?).to be true
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a new major release of Xcode' do
    it 'recognizes a major release' do
      xcode = MacOS::Xcode::Version.new('9.0')
      expect(xcode.major_release?).to be true
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a new major release of Xcode' do
    it 'recognizes a major release' do
      xcode = MacOS::Xcode::Version.new('9.0.0')
      expect(xcode.major_release?).to be true
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a minor release of Xcode' do
    it 'recognizes a minor release' do
      xcode = MacOS::Xcode::Version.new('9.1')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be true
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a minor release of Xcode' do
    it 'recognizes a minor release' do
      xcode = MacOS::Xcode::Version.new('9.1.0')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be true
      expect(xcode.patch_release?).to be false
    end
  end

  context 'when initalized with a patch release of Xcode' do
    it 'recognizes a patch release' do
      xcode = MacOS::Xcode::Version.new('9.0.1')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be true
    end
  end

  context 'when initalized with a patch release of Xcode' do
    it 'recognizes a patch release' do
      xcode = MacOS::Xcode::Version.new('0.3.3')
      expect(xcode.major_release?).to be false
      expect(xcode.minor_release?).to be false
      expect(xcode.patch_release?).to be true
    end
  end
end
