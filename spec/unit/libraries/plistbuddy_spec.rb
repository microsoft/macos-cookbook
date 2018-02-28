require 'spec_helper'

include MacOS

describe MacOS::PlistBuddy do
  let(:foo) { PlistBuddy.new 'Foo', 'path/to/file.plist' }
  let(:bar_baz) { PlistBuddy.new 'Bar Baz', 'path/to/file.plist' }
  let(:corge) { PlistBuddy.new 'Corge', 'path/to/com.why.Would You Do.this' }

  context 'when adding a non-container value to a missing entry' do
    it 'uses the add command and contains the data type and value' do
      expect(foo.add(true)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :Foo bool true'", 'path/to/file.plist']
    end
  end

  context 'when adding a non-container value to a missing entry with spaces' do
    it 'uses the add command, contains the data type, and escapes spaces' do
      expect(bar_baz.add(29.0)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Add :Bar\\ Baz float 29.0'", 'path/to/file.plist']
    end
  end

  context 'when setting a non-container value at an existing entry' do
    it 'uses the set command and does not contain the data type' do
      expect(foo.set(false)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :Foo false'", 'path/to/file.plist']
    end
  end

  context 'when setting a non-container value at an existing entry with spaces' do
    it 'uses the set command, does not contain the data type, and escapes spaces' do
      expect(bar_baz.set(false)).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :Bar\\ Baz false'", 'path/to/file.plist']
    end
  end

  context 'when deleting an entry' do
    it 'uses the delete command and only contains the entry' do
      expect(foo.delete).to eq ['/usr/libexec/PlistBuddy', '-c', "'Delete :Foo'", 'path/to/file.plist']
    end
  end

  context 'when printing an entry' do
    it 'uses the print command and only contains the entry' do
      expect(foo.print).to eq ['/usr/libexec/PlistBuddy', '-c', "'Print :Foo'", 'path/to/file.plist']
    end
  end

  context 'when modifying a plist that contains spaces' do
    it 'escapes the spaces in the file name' do
      expect(corge.print).to eq ['/usr/libexec/PlistBuddy', '-c', "'Print :Corge'", 'path/to/com.why.Would\\ You\\ Do.this']
    end
  end

  let(:qt_bundle_id) { PlistBuddy.new 'CFBundleIdentifier', '/Applications/QuickTime Player.app/Contents/Info.plist' }
  let(:chess_get_info) { PlistBuddy.new 'CFBundleGetInfoString', '/Applications/Chess.app/Contents/Info.plist' }
  let(:preview_doc_types) { PlistBuddy.new 'CFBundleDocumentTypes', '/Applications/Preview.app/Contents/Info.plist' }

  context 'when setting the CFBundleIdentifier property to com.apple.QuickTimePlayerX' do
    it 'formats the command and escapes the file name properly' do
      expect(qt_bundle_id.set('com.apple.QuickTimePlayerX')).to eq ['/usr/libexec/PlistBuddy', '-c', "'Set :CFBundleIdentifier com.apple.QuickTimePlayerX'", '/Applications/QuickTime\\ Player.app/Contents/Info.plist']
    end
  end

  context 'when adding a value with spaces to the CFBundleGetInfoString property' do
    it 'quotes the string value' do
      expect(chess_get_info.add('App version 1.0.1')).to eq ['/usr/libexec/PlistBuddy', '-c', "Add :CFBundleGetInfoString string \"App version 1.0.1\"", '/Applications/Chess.app/Contents/Info.plist']
    end
  end

  context 'when adding a new item of type dict to the CFBundleDocumentTypes array' do
    it 'uses the add command and contains a semi-colon at the end of the entry' do
      expect(preview_doc_types.insert(:dict)).to eq ['/usr/libexec/PlistBuddy', '-c', 'Add :CFBundleDocumentTypes: dict', '/Applications/Preview.app/Contents/Info.plist']
    end
  end

  context 'when adding a new item of type dict to the beginning of the CFBundleDocumentTypes array' do
    it 'uses the add command, specifies the 0th index, and specifies type' do
      expect(preview_doc_types.insert(:dict, 0)).to eq ['/usr/libexec/PlistBuddy', '-c', 'Add :CFBundleDocumentTypes:0 dict', '/Applications/Preview.app/Contents/Info.plist']
    end
  end

  context 'when deleting the first item in the array' do
    it 'uses the delete command and specifies the entry and the 0th index' do
      expect(preview_doc_types.delete(0)).to eq ['/usr/libexec/PlistBuddy', '-c', 'Delete :CFBundleDocumentTypes:0', '/Applications/Preview.app/Contents/Info.plist']
    end
  end

  context 'when deleting the entire CFBundleDocumentTypes array' do
    it 'formats the command properly' do
      expect(preview_doc_types.delete(0)).to eq ['/usr/libexec/PlistBuddy', '-c', 'Delete :CFBundleDocumentTypes', '/Applications/Preview.app/Contents/Info.plist']
    end
  end
end
