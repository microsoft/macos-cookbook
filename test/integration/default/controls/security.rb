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
