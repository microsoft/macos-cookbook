control 'keychain creation' do
  if platform_version?('10.11.6')
    describe file('/Users/vagrant/Library/Keychains/test.keychain') do
      it { should exist }
    end

  else
    describe file('/Users/vagrant/Library/Keychains/test.keychain-db') do
      it { should exist }
    end
  end
end
