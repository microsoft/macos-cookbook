require 'spec_helper'

include TypeConversion

describe TypeConverter, '.to_string_from_native' do
  context 'when given a boolean value' do
    it 'type and value returned as string' do
      expect(TypeConverter.to_string_from_native(true)).to eq 'bool true'
    end
  end
end

describe TypeConverter, '.to_native_from_string' do
  context 'when given a boolean type and false as zero' do
    it 'returns false' do
      expect(TypeConverter.to_native_from_string('boolean', '0')).to eq false
    end
  end

  context 'when given a boolean type and true as one' do
    it 'returns true' do
      expect(TypeConverter.to_native_from_string('boolean', '1')).to eq true
    end
  end
end
