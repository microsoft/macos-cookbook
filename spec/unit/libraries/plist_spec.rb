require 'spec_helper'

include MacOS::PlistHelpers

describe MacOS::PlistHelpers, '#plist_command' do
  context 'Adding a value to a plist' do
    it 'the bool arguments contain the data type' do
      expect(plistbuddy_command(:add, 'FooEntry', 'path/to/file.plist', true)).to eq "/usr/libexec/PlistBuddy -c 'Add :\"FooEntry\" bool' \"path/to/file.plist\""
    end

    it 'the add command only adds the data type' do
      expect(plistbuddy_command(:add, 'QuuxEntry', 'path/to/file.plist', 50)).to eq "/usr/libexec/PlistBuddy -c 'Add :\"QuuxEntry\" integer' \"path/to/file.plist\""
    end

    it 'the delete command is formatted properly' do
      expect(plistbuddy_command(:delete, 'BarEntry', 'path/to/file.plist')).to eq "/usr/libexec/PlistBuddy -c 'Delete :\"BarEntry\"' \"path/to/file.plist\""
    end

    it 'the set command is formatted properly' do
      expect(plistbuddy_command(:set, 'BazEntry', 'path/to/file.plist', false)).to eq "/usr/libexec/PlistBuddy -c 'Set :\"BazEntry\" false' \"path/to/file.plist\""
    end

    it 'the print command is formatted properly' do
      expect(plistbuddy_command(:print, 'QuxEntry', 'path/to/file.plist')).to eq "/usr/libexec/PlistBuddy -c 'Print :\"QuxEntry\"' \"path/to/file.plist\""
    end

    xit 'the add command is formatted properly when adding a new array with multiple items' do
      expect(plistbuddy_command(:add, 'QuuxArray', 'path/to/file.plist', ['Baz', 15])).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":0 string Baz' \"path/to/file.plist\"", "/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":1 integer 15' \"path/to/file.plist\""]
    end

    it 'the add command is formatted properly when adding a new array' do
      expect(plistbuddy_command(:add, 'QuuxArray', 'path/to/file.plist', ['Baz'])).to eq "/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":0 string Baz' \"path/to/file.plist\""
    end
  end

  context 'The value provided contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(plistbuddy_command(:print, 'Foo Bar Baz', 'path/to/file.plist')).to eq "/usr/libexec/PlistBuddy -c 'Print :\"Foo Bar Baz\"' \"path/to/file.plist\""
    end
  end

  context 'The value to be added contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(plistbuddy_command(:add, 'Foo Bar Baz', 'path/to/file.plist', true)).to eq "/usr/libexec/PlistBuddy -c 'Add :\"Foo Bar Baz\" bool' \"path/to/file.plist\""
    end
  end

  context 'The plist itself contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(plistbuddy_command(:print, 'Foo Bar Baz', 'Library/Preferences/com.parallels.Parallels Desktop.plist')).to eq "/usr/libexec/PlistBuddy -c 'Print :\"Foo Bar Baz\"' \"Library/Preferences/com.parallels.Parallels Desktop.plist\""
    end
  end
end

describe MacOS::PlistHelpers, '#convert_to_data_type_from_string' do
  context 'When the type is boolean and given a 1 or 0' do
    it 'returns true if entry is 1' do
      expect(convert_to_data_type_from_string('boolean', '1')).to eq true
    end

    it 'returns false if entry is 0' do
      expect(convert_to_data_type_from_string('boolean', '0')).to eq false
    end
  end

  context 'When the type is integer and the value is 1' do
    it 'returns the value as an integer' do
      expect(convert_to_data_type_from_string('integer', '1')).to eq 1
    end
  end

  context 'When the type is integer and the value is 0' do
    it 'returns the value as an integer' do
      expect(convert_to_data_type_from_string('integer', '0')).to eq 0
    end
  end

  context 'When the type is integer and the value is 950224' do
    it 'returns the correct value as an integer' do
      expect(convert_to_data_type_from_string('integer', '950224')).to eq 950224
    end
  end

  context 'When the type is string and the value is also a string' do
    it 'returns the correct value still as a string' do
      expect(convert_to_data_type_from_string('string', 'corge')).to eq 'corge'
    end
  end

  context 'When the type is float and the value is 3.14159265359' do
    it 'returns the correct value as a float' do
      expect(convert_to_data_type_from_string('float', '3.14159265359')).to eq 3.14159265359
    end
  end

  context 'When the type nor the value is given' do
    it 'returns an empty string' do
      expect(convert_to_data_type_from_string(nil, '')).to eq ''
    end
  end
end

describe MacOS::PlistHelpers, '#type_to_commandline_string' do
  context 'When given a certain data type' do
    it 'returns the required boolean entry type as a string' do
      expect(type_to_commandline_string(true)).to eq 'bool'
    end

    it 'returns the required array entry type as a string' do
      expect(type_to_commandline_string(%w(foo bar))).to eq ['0 string foo', '1 string bar']
    end

    it 'returns the required dictionary entry type as a string' do
      expect(type_to_commandline_string('baz' => 'qux')).to eq 'dict'
    end

    it 'returns the required string entry type as a string' do
      expect(type_to_commandline_string('quux')).to eq 'string'
    end

    it 'returns the required integer entry type as a string' do
      expect(type_to_commandline_string(1)).to eq 'integer'
    end

    it 'returns the required float entry type as a string' do
      expect(type_to_commandline_string(1.0)).to eq 'float'
    end
  end
end

describe MacOS::PlistHelpers, '#plist_array_handler' do
  context 'When given an array with strings and integer data types' do
    it 'returns the required command line syntax' do
      expect(plist_array_handler(['foo', 4])).to eq ['0 string foo', '1 integer 4']
    end
  end

  context 'When given an array with boolean and integer data types' do
    it 'returns the required command line syntax' do
      expect(plist_array_handler([false, 6])).to eq ['0 bool false', '1 integer 6']
    end
  end
end

describe MacOS::PlistHelpers, '#convert_to_string_from_data_type' do
  context 'When given a certain data type' do
    it 'returns the required boolean entry' do
      expect(convert_to_string_from_data_type(true)).to eq 'bool true'
    end

    # TODO: Skip until proper array support is implemented (i.e. containers)
    xit 'returns the required array entry' do
      expect(convert_to_string_from_data_type(%w(foo bar))).to eq ['0 string foo', '1 string bar']
    end

    # TODO: Skip until proper dict support is implemented (i.e. containers)
    xit 'returns the required dictionary entry' do
      expect(convert_to_string_from_data_type('baz' => 'qux')).to eq 'dict key value'
    end

    it 'returns the required string entry' do
      expect(convert_to_string_from_data_type('quux')).to eq 'string quux'
    end

    it 'returns the required integer entry' do
      expect(convert_to_string_from_data_type(1)).to eq 'integer 1'
    end

    it 'returns the required float entry' do
      expect(convert_to_string_from_data_type(1.0)).to eq 'float 1.0'
    end
  end
end
