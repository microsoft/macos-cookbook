macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip

control 'keychain creation' do
  if macos_version == '10.11.6'
    describe file('/Users/vagrant/Library/Keychains/test.keychain') do
      it { should exist }
    end

  else
    describe file('/Users/vagrant/Library/Keychains/test.keychain-db') do
      it { should exist }
    end
  end
end
