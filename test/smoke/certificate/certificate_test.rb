control 'certificate install' do
  describe file('/Users/vagrant/Test.p12') do
    it { should exist }
  end

  describe command('/usr/bin/security find-certificate /Users/vagrant/Library/Keychains/login.keychain') do
    its('stdout') { should include 'Test' }
  end
end
