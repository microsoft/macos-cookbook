require 'spec_helper'

include MacOS::PlistBuddyHelpers

describe MacOS::PlistBuddyHelpers, '#format_plistbuddy_command' do
  context 'When given some commands' do
    it 'the command is formatted properly' do
      expect(format_plistbuddy_command(:add, 'DidSeeSiriSetup', true)).to eq "/usr/libexec/Plistbuddy -c 'Add :DidSeeSiriSetup bool TRUE'"
    end
  end
end

describe MacOS::PlistBuddyHelpers, '#convert_to_string_from_data_type' do
  context 'When given a certain data type' do
    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type(true)).to eq 'bool TRUE'
    end

    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type(%w(foo bar))).to eq "array ['foo', 'bar']"
    end

    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type('baz' => 'qux')).to eq "dict {'baz' => 'qux'}"
    end

    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type('quux')).to eq 'string quux'
    end

    it 'returns the required PlistBuddy boolean entry' do
      expect(convert_to_string_from_data_type(1)).to eq 'int 1'
    end
  end
end
