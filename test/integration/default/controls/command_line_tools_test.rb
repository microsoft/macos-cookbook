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

  describe command('/usr/sbin/softwareupdate --list') do
    its('stdout') { should_not include 'Command Line Tools' }
  end
end
