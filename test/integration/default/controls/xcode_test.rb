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
