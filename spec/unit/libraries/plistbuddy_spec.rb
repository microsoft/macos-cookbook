require 'spec_helper'
include PlistBuddy::Helper

context 'When given some commands' do
  it 'the command is formatted properly' do
    expect(Plist.format_plistbuddy_command(:add, 'DidSeeSiriSetup', 0)).to eq "/usr/libexec/Plistbuddy -c ':Add DidSiriSetup 0'"
  end
end
