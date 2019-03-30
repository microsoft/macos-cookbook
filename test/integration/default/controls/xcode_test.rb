title 'xcode'

control 'xcode-and-simulators' do
  title 'integrated development environment for macOS'
  desc '
    Verify that Xcode exists and the app bundle replaced the symlink from install
  '
  describe directory('/Applications/Xcode.app') do
    it { should exist }
    it { should_not be_symlink }
  end
end

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
