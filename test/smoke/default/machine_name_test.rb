macos_semantic_version = command('sw_vers -productVersion').stdout.strip
friendly_pattern = Regexp.union("New#{macos_semantic_version}_Washing_Machine")
hostname_pattern = Regexp.union("New#{os[:release].tr('.', '')}WashingMachine")

control 'machine-name' do
  desc "machine name is set to the format \"New#{macos_semantic_version}_Washing_Machine\""

  %w(HostName LocalHostName).each do |hostname_command|
    describe command("scutil --get #{hostname_command}") do
      its('stdout') { should match hostname_pattern }
    end

    describe command('scutil --get ComputerName') do
      its('stdout') { should match friendly_pattern }
    end
  end
end
