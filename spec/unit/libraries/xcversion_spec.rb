require 'spec_helper'
include MacOS

describe MacOS::XCVersion do
  context 'when given an Xcode object with a download url' do
    it 'returns the appropriate --url syntax containing the url' do
      xcode = MacOS::Xcode.new('10.0', '/Applications/Xcode.app', 'https://www.apple.com')
      expect(XCVersion.download_url_option(xcode)).to eq "--url='https://www.apple.com'"
    end
  end

  context 'when given an Xcode object without a download url' do
    before do
      allow(MacOS::XCVersion).to receive(:available_versions).and_return(["10 GM seed\n"])
    end
    it 'returns the appropriate --url syntax' do
      xcode = MacOS::Xcode.new('10.0', '/Applications/Xcode.app', '')
      expect(XCVersion.download_url_option(xcode)).to eq ''
    end
  end
end
