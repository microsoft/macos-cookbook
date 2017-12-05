control 'xcode' do
  desc 'application Xcode exists and Developer mode is enabled'

  describe file('/Applications/Xcode.app') do
    it { should exist }
    it { should be_symlink }
  end

  describe directory('/Applications/Xcode-9.1.app') do
    it { should exist }
  end

  describe command('/usr/local/bin/xcversion simulators') do
    its('stdout') { should match(/iOS 10\.3\.1 Simulator \(installed\)/) }
  end
end
