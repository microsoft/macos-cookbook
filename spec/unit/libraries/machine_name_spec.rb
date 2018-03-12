require 'spec_helper'

include MacOS::MachineName

describe MacOS::MachineName, '#conform_to_dns_standards' do
  context 'when conforming an already compliant name' do
    it 'does not change the name' do
      expect(conform_to_dns_standards('New10134-Washing-Machine')).to eq 'New10134-Washing-Machine'
    end
  end

  context 'when conforming name with periods and underscores' do
    it 'removes periods, replaces underscores with hyphens, and does not touch casing' do
      expect(conform_to_dns_standards('New10.13.4_Washing_Machine')).to eq 'New10134-Washing-Machine'
    end
  end

  context 'when conforming name with two underscores in a row' do
    it 'all underscores replaced with hyphens' do
      expect(conform_to_dns_standards('New_Washing_Machine__042')).to eq 'New-Washing-Machine--042'
    end
  end

  context 'when conforming that begins or ends with non-alphanumeric characters' do
    it 'strips the non-alphanumeric characters from beginning and end' do
      expect(conform_to_dns_standards('--New10.13.4_Washing_Machine__')).to eq 'New10134-Washing-Machine'
    end
  end

  context 'when a name contains whitespace and apostraphes' do
    it 'replaces spaces with hyphens and removes apostraphes' do
      expect(conform_to_dns_standards("Johnny's MacBookPro")).to eq 'Johnnys-MacBookPro'
    end
  end

  context 'when a name contains only symbols and numbers' do
    it 'sets the name to numbers only' do
      expect(conform_to_dns_standards("!\"\#$%&'()*+,-./0123456789:;<=>?")).to eq '0123456789'
    end
  end

  context 'when conforming a name that is 64 characters or longer' do
    let(:shortened_name) { conform_to_dns_standards('cCdefSFwH3LnKE7pXKNqlIb2BmAjUplOeL95fHTnQGsovT91DHJuifnEwhzNfqlah4DxUC') }

    it 'shortens the name to 63 characters' do
      expect(shortened_name).to eq 'cCdefSFwH3LnKE7pXKNqlIb2BmAjUplOeL95fHTnQGsovT91DHJuifnEwhzNfql'
      expect(shortened_name.length).to eq 63
    end
  end
end
