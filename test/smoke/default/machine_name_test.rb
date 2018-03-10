macos_semantic_version = command('sw_vers -productVersion').stdout.strip

control 'machine-name' do
  desc "machine name is set to the format \"New#{macos_semantic_version}_Washing_Machine\""

  describe command('scutil --get LocalHostName') do
    its('stdout') { should match Regexp.union("New#{macos_semantic_version.tr('.', '')}WashingMachine") }
  end

  describe command('scutil --get HostName') do
    its('stdout') { should match Regexp.union("New#{macos_semantic_version.tr('.', '')}WashingMachine.body-of-swirling-water.com") }
  end

  describe command('scutil --get ComputerName') do
    its('stdout') { should match Regexp.union("New#{macos_semantic_version}_Washing_Machine") }
  end
end
