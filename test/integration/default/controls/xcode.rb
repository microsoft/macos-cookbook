title 'xcode'

control 'xcode/simulators' do
  title 'integrated development environment for macOS'
  desc '
    Verify that Xcode exists, developer mode is enabled, and the expected
    simulators are installed using the xcversion commandline utility
  '

  macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip

  describe file('/Applications/Xcode.app') do
    it { should exist }
    it { should be_symlink }
  end

  if macos_version.match? Regexp.union ['10.12', '10.13']
    describe directory('/Applications/Xcode-9.2.app') do
      it { should exist }
    end

    describe command('/opt/chef/embedded/bin/xcversion simulators') do
      sim_pattern = Regexp.union 'iOS 10.3.1 Simulator (installed)'
      its('stdout') { should match sim_pattern }
      its('exit_status') { should eq 0 }
    end

  elsif macos_version.match? Regexp.union '10.11'
    describe directory('/Applications/Xcode-8.2.1.app') do
      it { should exist }
    end

    describe command('/opt/chef/embedded/bin/xcversion simulators') do
      sim_pattern = Regexp.union 'iOS 9.3 Simulator (installed)'
      its('stdout') { should match sim_pattern }
      its('exit_status') { should eq 0 }
    end
  end
end
