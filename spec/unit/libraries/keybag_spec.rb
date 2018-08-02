require 'spec_helper'

include MacOS

describe Keybag do
  before(:example) do
    file = 'spec/test_configurations/chef.yml'
    allow(subject).to receive(:path).and_return('spec/unit/test_data/user.kb')
    allow(System::Hardware.uuid).to receive(:uuid).and_return('B01C7639-0955-5014-845A-214B1A4D859F')
  end

  describe '#analyze' do
    it 'returns the decoded data from the given blob' do
      test_blob = "UUID\x00\x00\x00\x10\b\xAFy\f\x80\x01DA\x83[\xDF\x91/\xB8M\xB8"
      expect(subject.analyze(test_blob, 0)).to eq(key: 'UUID', length: 16, start: 8, end: 24)
    end
  end
end
