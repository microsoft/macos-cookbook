require 'spec_helper'

include MacOS

describe MacOS::PlistBuddy do
  foo_entry = PlistBuddy.new('FooEntry', 'path/to/file.plist')
  foo_bar_baz = PlistBuddy.new('Foo Bar Baz', 'path/to/file.plist')
  parallels_entry = PlistBuddy.new('Foo Bar Baz', 'Library/Preferences/com.parallels.Parallels Desktop.plist')
  quux_array = PlistBuddy.new('QuuzArray', 'path/to/file.plist')

  context 'Adding a value to a plist' do
    it 'the bool arguments contain the data type' do
      expect(foo_entry.add(true)).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"FooEntry\" bool true' \"path/to/file.plist\""]
    end

    it 'the add command only adds the data type' do
      expect(foo_entry.add(50)).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"FooEntry\" integer 50' \"path/to/file.plist\""]
    end

    it 'the delete command is formatted properly' do
      expect(foo_entry.delete).to eq ["/usr/libexec/PlistBuddy -c 'Delete :\"FooEntry\"' \"path/to/file.plist\""]
    end

    it 'the set command is formatted properly' do
      expect(foo_entry.set(false)).to eq ["/usr/libexec/PlistBuddy -c 'Set :\"FooEntry\" false' \"path/to/file.plist\""]
    end

    it 'the print command is formatted properly' do
      expect(foo_entry.print).to eq ["/usr/libexec/PlistBuddy -c 'Print :\"FooEntry\"' \"path/to/file.plist\""]
    end

    xit 'the add command is formatted properly when adding a new array with multiple items' do
      expect(quux_array.add(['Baz', 15])).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":0 string Baz' \"path/to/file.plist\"", "/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":1 integer 15' \"path/to/file.plist\""]
    end

    xit 'the add command is formatted properly when adding a new array' do
      expect(quux_array.add(['Baz'])).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":0 string Baz' \"path/to/file.plist\""]
    end
  end

  context 'The value provided contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(foo_bar_baz.print).to eq ["/usr/libexec/PlistBuddy -c 'Print :\"Foo Bar Baz\"' \"path/to/file.plist\""]
    end
  end

  context 'The value to be added contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(foo_bar_baz.add(true)).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"Foo Bar Baz\" bool true' \"path/to/file.plist\""]
    end
  end

  context 'The plist itself contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(parallels_entry.print).to eq ["/usr/libexec/PlistBuddy -c 'Print :\"Foo Bar Baz\"' \"Library/Preferences/com.parallels.Parallels Desktop.plist\""]
    end
  end
end

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
