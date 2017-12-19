require 'spec_helper'
include MacOS::Xcode

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
      s = MacOS::Xcode::Simulator.new('11')
      expect(s.version).to eq 'iOS 11.1'
    end
    it 'returns the latest semantic version of iOS 10' do
      s = MacOS::Xcode::Simulator.new('10')
      expect(s.version).to eq 'iOS 10.3.1'
    end
    it 'returns the latest semantic version of iOS 9' do
      s = MacOS::Xcode::Simulator.new('9')
      expect(s.version).to eq 'iOS 9.3'
    end
  end
end
