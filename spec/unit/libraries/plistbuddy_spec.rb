require 'spec_helper'

include MacOS::PlistBuddyHelpers

describe MacOS::PlistBuddyHelpers, '#format_plistbuddy_command' do
  context 'When given some commands' do
    it 'the command is formatted properly' do
      expect(format_plistbuddy_command(:add, 'DidSeeSiriSetup', 0)).to eq "/usr/libexec/Plistbuddy -c ':Add DidSeeSiriSetup 0'"
    end
  end
end
