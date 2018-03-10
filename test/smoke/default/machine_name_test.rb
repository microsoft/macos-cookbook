macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip
version_digits_only = macos_semantic_version.tr '.', ''

control 'machine-name' do
  desc 'machine name is set to the correct format for the various types'

  describe command('scutil --get HostName') do
    its('stdout') { should eq "New#{version_digits_only}-Washing-Machine.body-of-swirling-water.com" }
  end

  describe command('scutil --get LocalHostName') do
    its('stdout') { should eq "New#{version_digits_only}-Washing-Machine.local" }
  end

  describe command('scutil --get ComputerName') do
    its('stdout') { should eq "New#{macos_version}_Washing_Machine" }
  end
end
