control 'keychian creation' do
  describe file('/Users/vagrant/Library/Keychains/test.keychain') do
    it { should exist }
  end

  # describe command('/usr/bin/security find-certificate /Users/vagrant/Library/Keychains/login.keychain') do
  #   its('stdout') { should include 'Test' }
  # end
end
