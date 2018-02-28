require 'spec_helper'

include MacOS::PlistHelpers

describe MacOS::PlistHelpers, '#entry_type_to_string' do
  context 'When given a non-container data type' do
    it 'returns the required boolean entry type as a string' do
      expect(entry_type_to_string(true)).to eq 'bool'
    end

    it 'returns the required string entry type as a string' do
      expect(entry_type_to_string('quux')).to eq 'string'
    end

    it 'returns the required integer entry type as a string' do
      expect(entry_type_to_string(1)).to eq 'integer'
    end

    it 'returns the required float entry type as a string' do
      expect(entry_type_to_string(1.0)).to eq 'float'
    end
  end

  context 'when give a value of type array and the array items are the same type' do
    it 'returns a list with indeces, types, and values' do
      expect(entry_type_to_string(%w(curve ball))).to eq ['0 string curve', '1 string ball']
    end
  end

  context 'when give a value of type array and the contents are of varying types' do
    it 'returns a list with indeces, types, and values' do
      expect(entry_type_to_string(['universe', 42])).to eq ['0 string universe', '1 integer 42']
    end
  end

  context 'when give a value of type array with more than two items and varying data types' do
    it 'returns a list with indeces, types, and values' do
      expect(entry_type_to_string([false, 6, 'quux'])).to eq ['0 bool false', '1 integer 6', '2 string quux']
    end
  end

  context 'when given a value of type dict' do
    xit 'returns the required dictionary entry type as a string' do
      expect(entry_type_to_string('baz' => 'qux')).to eq 'dict'
    end
  end
end
