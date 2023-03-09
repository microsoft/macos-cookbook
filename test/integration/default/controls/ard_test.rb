control 'remote-control' do
  title 'ensure the correct configuration of ARD'
  desc  'ensure that the ARD is enabled and configured to grant the correct privileges to the correct users'

  describe command('/usr/bin/defaults read /Library/Preferences/com.apple.RemoteManagement') do
    its('stdout') { should match /"ARD_AllLocalUsers" = 1/ }
  end

  describe command('/usr/bin/defaults read /Library/Preferences/com.apple.RemoteDesktop') do
    its('stdout') { should match /Text1 = \w+/ }
    its('stdout') { should match /Text2 = \w+/ }
    its('stdout') { should match /Text3 = ""/ }
    its('stdout') { should match /Text4 = ""/ }
  end

  if Chef::Version.new(os.release) >= Chef::Version.new('12.0.0')
    describe command('sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/tccstate') do
      its('stdout') { should match Regexp.new('<key>postEvent<\/key>.\s+<true\/>', Regexp::MULTILINE) }
      its('stdout') { should match Regexp.new('<key>screenCapture<\/key>.\s+<true\/>', Regexp::MULTILINE) }
    end
  end

  describe file('/Library/Application Support/Apple/Remote Desktop/RemoteManagement.launchd') do
    it { should exist }
    its('content') { should match 'enabled' }
  end
end
