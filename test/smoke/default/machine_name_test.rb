macos_semantic_version = command('sw_vers -productVersion').stdout.strip
friendly_pattern = Regexp.union("New#{macos_semantic_version}_Washing_Machine")
hostname_pattern = Regexp.union("New#{os[:release].tr('.', '')}WashingMachine.body-of-swirling-water.com")

control 'machine-name' do
  desc "machine name is set to the format \"New#{macos_semantic_version}_Washing_Machine\""

  describe command('scutil --get LocalHostName') do
    its('stdout') { should match hostname_pattern }
  end

  describe command('scutil --get HostName') do
    its('stdout') { should match hostname_pattern }
  end

  describe command('scutil --get ComputerName') do
    its('stdout') { should match friendly_pattern }
  end
end
