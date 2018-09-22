title 'xcode'

control 'xcode-and-simulators' do
  title 'integrated development environment for macOS'
  desc '
    Verify that Xcode exists, and the expected simulators are installed using
    the xcversion commandline utility
  '

  macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip
  describe directory('/Applications/Xcode.app') do
    it { should exist }
    it { should_not be_symlink }
  end

  if macos_version.match? Regexp.union '10.12'
    describe command('/opt/chef/embedded/bin/xcversion simulators') do
      its('exit_status') { should eq 0 }
      its('stdout') { should include 'iOS 10.3.1 Simulator (installed)' }
    end

  elsif macos_version.match? Regexp.union '10.11'
    describe command('/opt/chef/embedded/bin/xcversion simulators') do
      its('exit_status') { should eq 0 }
      its('stdout') { should include 'iOS 9.3 Simulator (installed)' }
    end
  end
end

control 'xcode-beta' do
  title 'beta integrated development environment for macOS'
  desc '
    Verify that Xcode exists in a beta-supported platform
  '

  macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip
  if macos_version.match? Regexp.union '10.13'
    describe directory('/Applications/Xcode.app') do
      it { should exist }
      it { should_not be_symlink }
    end
  end
end
