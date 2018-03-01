require 'spec_helper'
include MacOS

describe MacOS::SecurityCommand do
  context 'when SecurityCommand object is instantiated' do
    it 'security should use /usr/bin/security' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '')
      expect(test.security).to eq '/usr/bin/security'
    end
  end

  context 'when SecurityCommand object is instantiated' do
    it 'returns a certificate matching the specified certificate' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '')
      expect(test.cert).to eq '/Users/vagrant/Test.p12'
    end
  end

  context 'when SecurityCommand object is instantiated' do
    it 'returns a keychain matching the specified keychain' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '')
      expect(test.keychain).to eq ''
    end
  end

  context 'Unlocking a keychain' do
    it 'unlocks a keychain matching the specified command' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '')
      expect(test.unlock_keychain('password')).to eq ['/usr/bin/security', 'unlock-keychain', '-p', 'password']
    end
  end

  context 'importing a certificate (.p12)' do
    it 'imports a specified .p12 certificate file' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '')
      expect(test.import('password')).to eq ['/usr/bin/security', 'import', '/Users/vagrant/Test.p12', '-P', 'password', '']
    end
  end

  context 'adding a certificate (.cer)' do
    it 'adds a specified .cer certificate file' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.cer', '')
      expect(test.add_certificates).to eq ['/usr/bin/security', 'add-certificates', '/Users/vagrant/Test.cer']
    end
  end

  context 'adding a certificate (.cer) to a certain keychain' do
    it 'adds a specified .cer certificate file' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.cer', 'test.keychain')
      expect(test.add_certificates).to eq ['/usr/bin/security', 'add-certificates', '/Users/vagrant/Test.cer', '-k', 'test.keychain']
    end
  end

  context 'installing a certificate (.p12)' do
    it 'installs a specified .p12 certificate file' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '')
      expect(test.install_certificate('password')).to eq ['/usr/bin/security', 'import', '/Users/vagrant/Test.p12', '-P', 'password', '']
    end
  end

  context 'installing a certificate (.cer)' do
    it 'adds a specified .cer certificate file' do
      test = MacOS::SecurityCommand.new('/Users/vagrant/Test.cer', '')
      expect(test.install_certificate('password')).to eq ['/usr/bin/security', 'add-certificates', '/Users/vagrant/Test.cer']
    end
  end
end
