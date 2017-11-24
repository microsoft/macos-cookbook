require 'spec_helper'

include MacOS::PlistBuddyHelpers

describe MacOS::PlistBuddyHelpers, '#format_plistbuddy_command' do
  context 'Adding a value to a plist' do
    it 'the bool arguments contain the data type' do
      expect(format_plistbuddy_command(:add, 'FooEntry', true)).to eq "/usr/libexec/PlistBuddy -c 'Add :FooEntry bool true'"
    end

    it 'the int arguments contain the data type' do
      expect(format_plistbuddy_command(:add, 'QuuxEntry', 50)).to eq "/usr/libexec/PlistBuddy -c 'Add :QuuxEntry int 50'"
    end

    it 'the delete command is formatted properly' do
      expect(format_plistbuddy_command(:delete, 'BarEntry')).to eq "/usr/libexec/PlistBuddy -c 'Delete :BarEntry '"
    end

    it 'the set command is formatted properly' do
      expect(format_plistbuddy_command(:set, 'BazEntry', false)).to eq "/usr/libexec/PlistBuddy -c 'Set :BazEntry false'"
    end

    it 'the print command is formatted properly' do
      expect(format_plistbuddy_command(:print, 'QuxEntry')).to eq "/usr/libexec/PlistBuddy -c 'Print :QuxEntry '"
    end
  end
end

describe MacOS::PlistBuddyHelpers, '#convert_to_string_from_data_type' do
  context 'When given a certain data type' do
    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type(true)).to eq 'bool true'
    end

    xit 'returns the required PlistBuddy array entry' do # TODO: Implement proper plist array syntax (i.e. containers)
      expect(convert_to_string_from_data_type(%w(foo bar))).to eq 'array foo bar'
    end

    xit 'returns the required PlistBuddy dictionary entry' do # TODO: Implement proper plist dict syntax (i.e. containers)
      expect(convert_to_string_from_data_type('baz' => 'qux')).to eq 'dict key value'
    end

    it 'returns the required PlistBuddy string entry' do
      expect(convert_to_string_from_data_type('quux')).to eq 'string quux'
    end

    it 'returns the required PlistBuddy int entry' do
      expect(convert_to_string_from_data_type(1)).to eq 'int 1'
    end

    it 'returns the required PlistBuddy float entry' do
      expect(convert_to_string_from_data_type(1.0)).to eq 'float 1.0'
    end
  end

  context 'The value provided contains spaces' do
    it 'returns the value properly formatted with double quotes' do
      expect(format_plistbuddy_command(:print, 'Foo Bar Baz')).to eq "/usr/libexec/PlistBuddy -c 'Print :\"Foo Bar Baz\" '"
    end
  end
end
