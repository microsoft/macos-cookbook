describe MacOS::PlistHelpers, '#convert_to_data_type_from_string' do
  context 'When the type is boolean and given a 1 or 0' do
    xit 'returns true if entry is 1' do
      expect(convert_to_data_type_from_string('boolean', '1')).to eq true
    end

    xit 'returns false if entry is 0' do
      expect(convert_to_data_type_from_string('boolean', '0')).to eq false
    end
  end

  context 'When the type is integer and the value is 1' do
    xit 'returns the value as an integer' do
      expect(convert_to_data_type_from_string('integer', '1')).to eq 1
    end
  end

  context 'When the type is integer and the value is 0' do
    xit 'returns the value as an integer' do
      expect(convert_to_data_type_from_string('integer', '0')).to eq 0
    end
  end

  context 'When the type is integer and the value is 950224' do
    xit 'returns the correct value as an integer' do
      expect(convert_to_data_type_from_string('integer', '950224')).to eq 950224
    end
  end

  context 'When the type is string and the value is also a string' do
    xit 'returns the correct value still as a string' do
      expect(convert_to_data_type_from_string('string', 'corge')).to eq 'corge'
    end
  end

  context 'When the type is float and the value is 3.14159265359' do
    xit 'returns the correct value as a float' do
      expect(convert_to_data_type_from_string('float', '3.14159265359')).to eq 3.14159265359
    end
  end

  context 'When the type nor the value is given' do
    xit 'returns an empty string' do
      expect(convert_to_data_type_from_string(nil, '')).to eq ''
    end
  end
end

describe MacOS::PlistHelpers, '#type_to_commandline_string' do
  context 'When given a certain data type' do
    xit 'returns the required boolean entry type as a string' do
      expect(type_to_commandline_string(true)).to eq 'bool'
    end

    xit 'returns the required array entry type as a string' do
      expect(type_to_commandline_string(%w(foo bar))).to eq ['0 string foo', '1 string bar']
    end

    xit 'returns the required dictionary entry type as a string' do
      expect(type_to_commandline_string('baz' => 'qux')).to eq 'dict'
    end

    xit 'returns the required string entry type as a string' do
      expect(type_to_commandline_string('quux')).to eq 'string'
    end

    xit 'returns the required integer entry type as a string' do
      expect(type_to_commandline_string(1)).to eq 'integer'
    end

    xit 'returns the required float entry type as a string' do
      expect(type_to_commandline_string(1.0)).to eq 'float'
    end
  end
end

describe MacOS::PlistHelpers, '#plist_array_handler' do
  context 'When given an array with strings and integer data types' do
    xit 'returns the required command line syntax' do
      expect(plist_array_handler(['foo', 4])).to eq ['0 string foo', '1 integer 4']
    end
  end

  context 'When given an array with boolean and integer data types' do
    xit 'returns the required command line syntax' do
      expect(plist_array_handler([false, 6])).to eq ['0 bool false', '1 integer 6']
    end
  end
end

describe MacOS::PlistHelpers, '#convert_to_string_from_data_type' do
  context 'When given a certain data type' do
    xit 'returns the required boolean entry' do
      expect(convert_to_string_from_data_type(true)).to eq 'bool true'
    end

    xit 'returns the required string entry' do
      expect(convert_to_string_from_data_type('quux')).to eq 'string quux'
    end

    xit 'returns the required integer entry' do
      expect(convert_to_string_from_data_type(1)).to eq 'integer 1'
    end

    xit 'returns the required float entry' do
      expect(convert_to_string_from_data_type(1.0)).to eq 'float 1.0'
    end
  end
end
