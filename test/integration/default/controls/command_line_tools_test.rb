title 'xcode command line tools'

control 'command-line-tool-sentinel' do
  title 'Command Line Tools sentinel has been deleted'
  desc '
    Verify that the Command Line Tools sentinel has been deleted, and that
    there are no lingering CLT updates since we should have installed the latest
  '
  describe file('/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress') do
    it { should_not exist }
  end

  # False test failure due to multiple entries in Apple's SWU catalog
  # describe command('/usr/sbin/softwareupdate --list') do
  #   its('stdout') { should_not include 'Command Line Tools' }
  # end
end

control 'xcrun' do
  title 'xcrun binary installed by Command Line Tools'

  describe file('/Library/Developer/CommandLineTools/usr/lib/libxcrun.dylib') do
    it { should exist }
  end
end
