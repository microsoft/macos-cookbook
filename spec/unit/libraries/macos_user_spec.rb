require 'spec_helper'

include MacOS::MacOSUserHelpers

describe MacOS::MacOSUserHelpers, '#kcpassword_hash' do
  context 'When calling the obfuscate method on a short password' do
    it 'the password is obfuscated correctly' do
      expect(kcpassword_hash('password')).to eq "\r\xE8!P\xA5\xD3\xAF\x8E\xA3\xB9\x1F".force_encoding('ASCII-8BIT')
    end
  end

  context 'When calling the obfuscate method on a long password' do
    it 'the password hash value matches the binary content of the file' do
      expect(kcpassword_hash('correct-horse-battery-staple')).to eq "\x1E\xE6 Q\xB7\xDF\xA9\xC7\xCB\xD6m\x0E\xEC\x7FA\xB3\xC8\xA9\x8F\xD1\xC02\x0E\xFD3S\xBE\xD9\xDD\xEA\xA3\xB9\x1F".force_encoding('ASCII-8BIT')
    end
  end
end
