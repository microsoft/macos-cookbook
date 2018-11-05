title 'security'

control 'certificate-install' do
  title 'installation and discovery of a certificate'
  desc '
    Verify that a test certificate is able to be installed and can also
    be discovered via the security-find-certificate command
  '

  describe file('/Users/vagrant/Test.p12') do
    it { should exist }
  end

  describe command('/usr/bin/security find-certificate /Users/vagrant/Library/Keychains/login.keychain') do
    its('stdout') { should include 'Test' }
  end
end

control 'keychain-creation' do
  title 'creation of keychain'

  desc '
    Verify that a test keychain is able to be created and discoverable based
    on macOS version and file name.
    '
  describe file('/Users/vagrant/Library/Keychains/test.keychain-db') do
    it { should exist }
  end
end

control 'login-keychain-creation' do
  title 'creation of login keychain'

  desc '
    Verify that a test login keychain is able to be created and discoverable
    '
  describe user('testuser') do
    it { should exist }
  end

  describe file('/Users/testuser/Library/Keychains/login.keychain-db') do
    it { should exist }
  end

  describe command('/usr/bin/security login-keychain') do
    its('stdout') { should include 'login' }
  end
end
