require 'spec_helper'

include MacOS

describe MacOS::PlistBuddy do
  # foo_bar_baz = PlistBuddy.new('Foo Bar Baz', 'path/to/file.plist')
  # parallels_entry = PlistBuddy.new('Foo Bar Baz', 'Library/Preferences/com.parallels.Parallels Desktop.plist')
  # quux_array = PlistBuddy.new('QuuzArray', 'path/to/file.plist')

  let(:foo) { PlistBuddy.new 'Foo', 'path/to/file.plist' }
  let(:bar_baz) { PlistBuddy.new 'Bar Baz', 'path/to/some file.plist' }

  context 'when adding a value to a missing entry' do
    it 'uses the add command and contains the data type and value' do
      expect(foo.add(true)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :Foo bool true'", 'path/to/file.plist']
    end

    it 'uses the add command and contains the data type and value' do
      expect(foo.add(17)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :Foo integer 50'", 'path/to/file.plist']
    end

    it 'uses the add command and contains the data type and value' do
      expect(foo.add(19.0)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :Foo float 19.0'", 'path/to/file.plist']
    end

    it 'uses the add command and contains the data type and value' do
      expect(foo.add('bar')).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :Foo string bar'", 'path/to/file.plist']
    end
  end

  context 'when setting a boolean value at an existing entry' do
    it 'uses the set command and does not contain the data type' do
      expect(foo.set(false)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :Foo false'", 'path/to/file.plist']
    end

    it 'uses the set command and does not contain the data type' do
      expect(foo.set(23)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :Foo 50'", 'path/to/file.plist']
    end

    it 'uses the set command and does not contain the data type' do
      expect(foo.set(29.0)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :Foo 29.0'", 'path/to/file.plist']
    end

    it 'uses the set command and does not contain the data type' do
      expect(foo.set('bar')).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :Foo bar'", 'path/to/file.plist']
    end
  end

  context 'when deleting an entry' do
    it 'uses the delete command and only contains the entry' do
      expect(foo.delete).to eq ['/usr/libexec/PlistBuddy', '-c', "'Delete :Foo'", 'path/to/file.plist']
    end
  end

  context 'when printing an entry' do
    it 'uses the delete command and only contains the entry' do
      expect(foo.print).to eq ['/usr/libexec/PlistBuddy', '-c', "'Print :Foo'", 'path/to/file.plist']
    end
  end
end

describe Nonsense do
  context 'when modifing an entry with spaces'
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

it 'uses the add command and adds quotes for whitespace' do
  expect(bar_baz.add(true)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :\"Bar Baz\" bool true'", '"path/to/some file.plist"']
end

# context ''
#   it 'the set command is formatted properly' do
#     expect(foo_entry.set(false)).to eq ["/usr/libexec/PlistBuddy -c 'Set :\"FooEntry\" false' \"path/to/file.plist\""]
#   end
# end

# context 'adding an array and setting the value' do
#   xit 'the add command is formatted properly when adding a new array with multiple items' do
#     expect(quux_array.add(['Baz', 15])).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":0 string Baz' \"path/to/file.plist\"", "/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":1 integer 15' \"path/to/file.plist\""]
#   end
#
#   xit 'the add command is formatted properly when adding a new array' do
#     expect(quux_array.add(['Baz'])).to eq ["/usr/libexec/PlistBuddy -c 'Add :\"QuuxArray\":0 string Baz' \"path/to/file.plist\""]
#   end
# end

# Set the CFBundleIdentifier property to com.apple.plistbuddy:
#
#         Set :CFBundleIdentifier com.apple.plistbuddy
#
# Add the CFBundleGetInfoString property to the plist:
#
#         Add :CFBundleGetInfoString string "App version 1.0.1"
#
# Add a new item of type dict to the CFBundleDocumentTypes array:
#
#         Add :CFBundleDocumentTypes: dict
#
# Add the new item to the beginning of the array:
#
#         Add :CFBundleDocumentTypes:0 dict
#
# Delete the FIRST item in the array:
#
#         Delete :CFBundleDocumentTypes:0 dict
#
# Delete the ENTIRE CFBundleDocumentTypes array:
#
#         Delete :CFBundleDocumentTypes
