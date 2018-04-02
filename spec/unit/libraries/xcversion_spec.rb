require 'spec_helper'
include MacOS::XCVersion

describe "MacOS::XCVersion.install_xcode('10.0')" do
  context "when passed '10.0'" do
    before do
      allow(MacOS::XCVersion.install_xcode.to receive(:list_xcodes)
        { (<<-XCVERSION_OUTPUT
                    8
                    8.1
                    8.2
                    8.2.1
                    8.3
                    8.3.1
                    8.3.2
                    8.3.3
                    9
                    9.0.1
                    9.1
                    9.2
                    9.3
                    9.4 beta
                    10 GM seed
                    XCVERSION_OUTPUT
                   ) }
    end
    it 'returns the full xcversion install command for Xcode 10 GM seed' do
      expect(MacOS::XCVersion.install_xcode('10.0'))
        .to eq "/opt/chef/embedded/bin/xcversion install '10 GM seed'"
    end
  end
end

describe MacOS::XCVersion.install_xcode('9.4') do
  context "when passed '9.4'" do
    it 'returns the full xcversion install command for Xcode 9.4 beta' do
      expect(MacOS::XCVersion.install_xcode('9.4'))
        .to eq "/opt/chef/embedded/bin/xcversion install '9.4 beta'"
    end
  end
end

describe MacOS::XCVersion.install_xcode('9.0') do
  context "when passed '9.0'" do
    it 'returns the full xcversion install command for Xcode 9.0' do
      expect(MacOS::XCVersion.install_xcode('9.0'))
        .to eq "/opt/chef/embedded/bin/xcversion install '9'"
    end
  end
end

describe MacOS::XCVersion.install_xcode('8.3.3') do
  context "when passed '8.3.3'" do
    it 'returns the full xcversion install command for Xcode 8.3.3' do
      expect(MacOS::XCVersion.install_xcode('8.3.3'))
        .to eq "/opt/chef/embedded/bin/xcversion install '8.3.3'"
    end
  end
end

describe MacOS::XCVersion.install_xcode('8.2') do
  context "when passed '8.2'" do
    it 'returns the full xcversion install command for Xcode 8.2' do
      expect(MacOS::XCVersion.install_xcode('8.2'))
        .to eq "/opt/chef/embedded/bin/xcversion install '8.2'"
    end
  end
end

describe MacOS::XCVersion.apple_pseudosemantic_version('9.0') do
  context "when passed '9.0'" do
    it "returns '9'" do
      expect(MacOS::XCVersion.apple_pseudosemantic_version('9.0'))
        .to eq '9'
    end
  end
end

describe MacOS::XCVersion.apple_pseudosemantic_version('8.3.3') do
  context "when passed '8.3.3'" do
    it "returns '8.3.3'" do
      expect(MacOS::XCVersion.apple_pseudosemantic_version('8.3.3'))
        .to eq '8.3.3'
    end
  end
end

describe MacOS::XCVersion.apple_pseudosemantic_version('8.2') do
  context "when passed '8.2'" do
    it "it returns '8.2'" do
      expect(MacOS::XCVersion.apple_pseudosemantic_version('8.2'))
        .to eq '8.2'
    end
  end
end
