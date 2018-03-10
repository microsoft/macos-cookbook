require 'spec_helper'

include MacOS::MachineName

describe MacOS::MachineName, '#conform_to_rfc1034' do
  context 'when conforming an already compliant name' do
    it 'does not change the name' do
      expect(conform_to_rfc1034('New10134-Washing-Machine')).to eq 'New10134-Washing-Machine'
    end
  end

  context 'when conforming a non-compliant name' do
    it 'removes periods, replaces underscores with hyphens, and does not touch casing' do
      expect(conform_to_rfc1034('New10.13.4_Washing_Machine')).to eq 'New10134-Washing-Machine'
    end
  end

  context 'when conforming a name that is 64 characters or longer' do
    let(:shortened_name) { conform_to_rfc1034('cCdefSFwH3LnKE7pXKNqlIb2BmAjUplOeL95fHTnQGsovT91DHJuifnEwhzNfqlah4DxUC') }

    it 'shortens the name to 63 characters' do
      expect(shortened_name).to eq 'cCdefSFwH3LnKE7pXKNqlIb2BmAjUplOeL95fHTnQGsovT91DHJuifnEwhzNfql'
      expect(shortened_name.length).to eq 63
    end
  end
end
