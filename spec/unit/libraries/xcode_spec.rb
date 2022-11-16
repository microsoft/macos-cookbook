require 'spec_helper'
include MacOS

describe MacOS::Xcode do
  context 'when initialized without a download url and Xcode betas available' do
    before do
      allow_any_instance_of(MacOS::Xcode).to receive(:installed_path).and_return nil
      allow(MacOS::XCVersion).to receive(:available_versions)
        .and_return(['4.3 for Lion',
                     '4.3.1 for Lion',
                     '4.3.2 for Lion',
                     '4.3.3 for Lion',
                     '4.4',
                     '4.4.1',
                     '4.5',
                     '4.5.1',
                     '4.5.2',
                     '4.6',
                     '4.6.1',
                     '4.6.2',
                     '4.6.3',
                     '5',
                     '5.0.1',
                     '5.0.2',
                     '5.1',
                     '5.1.1',
                     '6.0.1',
                     '6.1',
                     '6.1.1',
                     '6.2',
                     '6.3',
                     '6.3.1',
                     '6.3.2',
                     '6.4',
                     '7',
                     '7.0.1',
                     '7.1',
                     '7.1.1',
                     '7.2',
                     '7.2.1',
                     '7.3',
                     '7.3.1',
                     '8',
                     '8.1',
                     '8.2',
                     '8.2.1',
                     '8.3',
                     '8.3.1',
                     '8.3.2',
                     '8.3.3',
                     '9',
                     '9.0.1',
                     '9.1',
                     '9.2',
                     '9.3',
                     '9.4.1',
                     '9.4.2 beta 2',
                     '9.4.2',
                     '10 beta 1',
                     '10 Release Candidate',
                     '10',
                     '10.1',
                     '10.2.1',
                     '10.2',
                     '10.3',
                     '11',
                     '11.1',
                     '11.2',
                     '11.2.1',
                     '11.3',
                     '11.3 beta',
                     '11.3.1',
                     '11.4 beta',
                     '11.4',
                     '11.4 beta 3',
                     '11.4 beta 2',
                     '11.4.1',
                     '11.5 beta',
                     '11.5',
                     '11.5 Release Candidate',
                     '11.5 beta 2',
                     '11.6 beta',
                     '11.6 beta 2',
                     '12 beta 4',
                     '12 for macOS Universal Apps beta',
                     '12 beta 3',
                     '12 beta 2',
                     '12 for macOS Universal Apps beta 2',
                     '12 beta'])
    end
    it 'returns the name of the latest Xcode 12 beta when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('12.0', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '12 beta 4'
      expect(xcode.version.call).to_not eq '12 beta'
      expect(xcode.version.call).to_not eq '12 for macOS Universal Apps beta'
    end
    it 'returns the name of the latest Xcode 11.6 beta when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('11.6', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '11.6 beta 2'
      expect(xcode.version.call).to_not eq '11.6 beta'
      expect(xcode.version.call).to_not eq '11.6 beta2'
    end
    it 'returns the name of Xcode 11.5 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('11.5', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '11.5'
      expect(xcode.version.call).to_not eq '11.5 beta'
      expect(xcode.version.call).to_not eq '11.5 Release Candidate'
    end
    it 'returns the name of Xcode 10 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('10.0', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '10'
      expect(xcode.version.call).to_not eq '10 Release Candidate'
      expect(xcode.version.call).to_not eq '10 beta 1'
    end
    it 'returns the name of Xcode 9.4.2 official when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.4.2', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '9.4.2'
      expect(xcode.version.call).to_not eq '9.4.2 beta 2'
      expect(xcode.version.call).to_not eq '9.4.2 beta 3'
    end
    it 'returns the temporary beta path set by xcversion when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.4.2', '/Applications/Xcode.app')
      expect(xcode.current_path).to eq '/Applications/Xcode-9.4.2.app'
    end
    it 'returns the name of Xcode 9.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.3', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '9.3'
    end
    it 'returns the name of Xcode 9 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('9.0', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '9'
    end
    it 'returns the name of Xcode 8.3.3 when initialized with the semantic version' do
      xcode = MacOS::Xcode.new('8.3.3', '/Applications/Xcode.app')
      expect(xcode.version.call).to eq '8.3.3'
    end
    it 'correctly determines platform compatibility for Xcode 11' do
      xcode = MacOS::Xcode.new('11.0', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be false
      expect(xcode.compatible_with_platform?('10.13.6')).to be false
      expect(xcode.compatible_with_platform?('10.13.2')).to be false
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for Xcode 10.3' do
      xcode = MacOS::Xcode.new('10.3', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be false
      expect(xcode.compatible_with_platform?('10.13.2')).to be false
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for Xcode 10.1' do
      xcode = MacOS::Xcode.new('10.1', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be false
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for Xcode 9.4.1' do
      xcode = MacOS::Xcode.new('9.4.1', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be true
      expect(xcode.compatible_with_platform?('10.12.6')).to be false
      expect(xcode.compatible_with_platform?('0')).to be false
    end
    it 'correctly determines platform compatibility for a vintage Xcode' do
      xcode = MacOS::Xcode.new('9.2', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be true
      expect(xcode.compatible_with_platform?('10.12.6')).to be true
      expect(xcode.compatible_with_platform?('0')).to be true # not enforcing compatibilty for vintage or obsolete Xcodes
    end
    it 'correctly determines platform compatibility for an obsolete Xcode' do
      xcode = MacOS::Xcode.new('8.2.1', '/Applications/Xcode.app')
      expect(xcode.compatible_with_platform?('10.14.4')).to be true
      expect(xcode.compatible_with_platform?('10.14.3')).to be true
      expect(xcode.compatible_with_platform?('10.13.6')).to be true
      expect(xcode.compatible_with_platform?('10.13.2')).to be true
      expect(xcode.compatible_with_platform?('10.12.6')).to be true
      expect(xcode.compatible_with_platform?('0')).to be true # not enforcing compatibilty for vintage or obsolete Xcodes
    end
  end
end

describe MacOS::Xcode do
  context 'when initialized with an Xcode download url and Xcode betas available' do
    before do
      allow(MacOS::XCVersion).to receive(:available_versions).and_return(['10 Release Candidate'])
    end
    it 'returns the download url' do
      xcode = MacOS::Xcode.new('10.0', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(xcode.download_url).to eq 'https://www.apple.com'
    end

    it 'ignores the Apple version list and uses the provided version' do
      xcode = MacOS::Xcode.new('0.0', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(xcode.version.call).to eq '0.0'
    end

    it 'ignores the Apple version list and uses the provided version' do
      xcode = MacOS::Xcode.new('2', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(xcode.version.call).to eq '2'
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
