require 'spec_helper'
include MacOS

describe MacOS::SecurityCommand do
  let(:p12_cert) { MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', '') }
  let(:p12_cert_kc) { MacOS::SecurityCommand.new('/Users/vagrant/Test.p12', 'test.keychain') }
  let(:cer_cert) { MacOS::SecurityCommand.new('/Users/vagrant/Test.cer', '') }
  let(:cer_cert_kc) { MacOS::SecurityCommand.new('/Users/vagrant/Test.cer', 'test.keychain') }

  context 'when SecurityCommand object is instantiated' do
    it 'security should use /usr/bin/security' do
      expect(p12_cert.security_cmd).to eq '/usr/bin/security'
    end
  end

  context 'when SecurityCommand object is instantiated' do
    it 'returns a certificate matching the specified certificate' do
      expect(p12_cert.cert).to eq '/Users/vagrant/Test.p12'
    end
  end

  context 'when SecurityCommand object is instantiated' do
    it 'returns a keychain matching the specified keychain' do
      expect(p12_cert.keychain).to eq ''
    end
  end

  context 'unlocking a keychain' do
    it 'unlocks a keychain matching the specified command' do
      expect(p12_cert.unlock_keychain('password')).to eq ['/usr/bin/security', 'unlock-keychain', '-p', 'password']
    end
  end

  context 'unlocking a keychain' do
    it 'unlocks a specific keychain matching the specified command' do
      expect(p12_cert_kc.unlock_keychain('password')).to eq ['/usr/bin/security', 'unlock-keychain', '-p', 'password', 'test.keychain']
    end
  end

  context 'importing a certificate (.p12)' do
    it 'imports a specified .p12 certificate file' do
      expect(p12_cert.import('password', [])).to eq ['/usr/bin/security', 'import', '/Users/vagrant/Test.p12', '-P', 'password']
    end
  end

  context 'importing a certificate (.p12)' do
    it 'imports a specified .p12 certificate file to a specified keychain' do
      expect(p12_cert_kc.import('password', [])).to eq ['/usr/bin/security', 'import', '/Users/vagrant/Test.p12', '-P', 'password', '-k', 'test.keychain']
    end
  end

  context 'importing a certificate (.p12) accessible by Mail and App Store ' do
    it 'imports a specified .p12 certificate file to a specified keychain' do
      expect(p12_cert_kc.import('password', ['/Applications/Mail.app', '/Applications/App Store.app'])).to eq ['/usr/bin/security', 'import', '/Users/vagrant/Test.p12', '-P', 'password', '-k', 'test.keychain', '-T', '/Applications/Mail.app', '-T', '/Applications/App Store.app']
    end
  end

  context 'adding a certificate (.cer)' do
    it 'adds a specified .cer certificate file' do
      expect(cer_cert.add_certificates).to eq ['/usr/bin/security', 'add-certificates', '/Users/vagrant/Test.cer']
    end
  end

  context 'adding a certificate (.cer) to a certain keychain' do
    it 'adds a specified .cer certificate file' do
      expect(cer_cert_kc.add_certificates).to eq ['/usr/bin/security', 'add-certificates', '/Users/vagrant/Test.cer', '-k', 'test.keychain']
    end
  end

  context 'installing a certificate (.p12)' do
    it 'installs a specified .p12 certificate file' do
      expect(p12_cert.install_certificate('password', [])).to eq ['/usr/bin/security', 'import', '/Users/vagrant/Test.p12', '-P', 'password']
    end
  end

  context 'installing a certificate (.cer)' do
    it 'adds a specified .cer certificate file' do
      expect(cer_cert.install_certificate('password', [])).to eq ['/usr/bin/security', 'add-certificates', '/Users/vagrant/Test.cer']
    end
  end
end
