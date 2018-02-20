control 'xcode' do
  desc 'application Xcode exists and Developer mode is enabled'

  describe file('/Applications/Xcode.app') do
    it { should exist }
    it { should be_symlink }
  end

  if os[:release].match?(/10\.13/) || os[:release].match?(/10\.12/)
    describe directory('/Applications/Xcode-9.2.app') do
      it { should exist }
    end

    describe command('/opt/chef/embedded/bin/xcversion simulators') do
      its('stdout') { should match(/iOS 10\.3\.1 Simulator \(installed\)/) }
    end

  elsif os[:release].match?(/10\.11/)
    describe directory('/Applications/Xcode-8.2.1.app') do
      it { should exist }
    end

    describe command('/opt/chef/embedded/bin/xcversion simulators') do
      its('stdout') { should match(/iOS 9\.3 Simulator \(installed\)/) }
    end
  end
end
