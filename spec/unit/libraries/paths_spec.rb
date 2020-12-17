require 'spec_helper'
include MacOS

user_name = 'test'

describe MacOS::UserPath, 'UserPath library helper functions' do
  context 'using UserPath library routines to create paths' do
    it 'home creates the correct path to user home' do
      expect(UserPath.home(user_name)).to eq "/Users/#{user_name}"
    end

    it "directory creates the correct paths directories in #{user_name}" do
      expect(UserPath.directory(user_name, 'how', 'now', 'brown', 'cow')).to eq "/Users/#{user_name}/how/now/brown/cow"
    end

    it 'library creates the correct path to user Library directory' do
      expect(UserPath.library(user_name)).to eq "/Users/#{user_name}/Library"
    end

    it 'preferences creates the correct path to user preference directory' do
      expect(UserPath.preferences(user_name)).to eq "/Users/#{user_name}/Library/Preferences"
    end

    it 'plist creates the correct path to the specified user plist' do
      expect(UserPath.plist(user_name, 'com.apple.screensaver.plist')).to eq "/Users/#{user_name}/Library/Preferences/com.apple.screensaver.plist"
    end
  end
end

describe MacOS::SystemPath, 'SystemPath library helper functions' do
  context 'using SystemPath library routines to create paths' do
    it 'directory creates the correct directory path' do
      expect(SystemPath.directory('how', 'now', 'brown', 'cow')).to eq '/how/now/brown/cow'
    end

    it 'root creates the correct system path' do
      expect(SystemPath.root).to eq '/'
    end

    it 'library creates the correct system library path' do
      expect(SystemPath.library).to eq '/Library'
    end

    it 'preferences creates the correct system preferences path' do
      expect(SystemPath.preferences).to eq '/Library/Preferences'
    end

    it 'plist creates the correct system preferences plist path' do
      expect(SystemPath.plist('com.apple.screensaver.plist')).to eq '/Library/Preferences/com.apple.screensaver.plist'
    end
  end
end
