require 'spec_helper'

include KcpasswordHelpers::Kcpassword

describe KcpasswordHelpers::Kcpassword, '#obfuscate' do
  context 'When calling the obfuscate method' do
    it 'the password is obfuscated correctly' do
      expect(KcpasswordHelpers::Kcpassword.obfuscate('password')).to eq "\r\xE8!P\xA5\xD3\xAF\x8E\xA3\xB9\x1F".force_encoding('ASCII-8BIT')
    end
  end
end
