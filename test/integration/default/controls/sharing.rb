title 'sharing'

control 'standardized-hostname' do
  impact 0.8
  title 'macOS named with the preferred style'
  desc '
    Verify the correct values for the user-friendly name,
    the local (Bonjour) name, and the name associated with hostname
  '

  macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip
  platform_and_version = [os[:name], macos_version.tr('.', '')].join('-')
  hostname_pattern = Regexp.union platform_and_version
  fqdn_pattern = Regexp.union [platform_and_version, 'vagrantup.com'].join('.')

  describe command('scutil --get ComputerName') do
    its('stdout.chomp') { should match hostname_pattern }
  end

  describe command('scutil --get LocalHostName') do
    its('stdout.chomp') { should match hostname_pattern }
  end

  describe command('scutil --get HostName') do
    its('stdout.chomp') { should match fqdn_pattern }
  end

  describe command('hostname') do
    its('stdout.chomp') { should match fqdn_pattern }
  end

  describe command('hostname -s') do
    its('stdout.chomp') { should match hostname_pattern }
  end

  describe command('hostname -f') do
    its('stdout.chomp') { should match fqdn_pattern }
  end
end

control 'nonstandard-computer-name' do
  impact 0.5
  title 'macOS named with an non-conventional style'
  desc '
    Verify the correct values for each of the three names are set,
    correctly, even when the name does not adhere to RFC 1034
  '

  ref 'https://tools.ietf.org/html/rfc1034'

  macos_version = command('/usr/bin/sw_vers -productVersion').stdout.strip
  computer_name_pattern = Regexp.union("New#{macos_version}_Washing_Machine")
  hostname = "New#{macos_version.tr('.', '')}-Washing-Machine"
  hostname_pattern = Regexp.union(hostname)
  fqdn_pattern = Regexp.union [hostname, 'body-of-swirling-water.com'].join('.')

  describe command('scutil --get ComputerName') do
    its('stdout.chomp') { should match computer_name_pattern }
  end

  describe command('scutil --get LocalHostName') do
    its('stdout.chomp') { should match hostname_pattern }
  end

  describe command('scutil --get HostName') do
    its('stdout.chomp') { should match fqdn_pattern }
  end

  describe command('hostname') do
    its('stdout.chomp') { should match fqdn_pattern }
  end

  describe command('hostname -s') do
    its('stdout.chomp') { should match hostname_pattern }
  end

  describe command('hostname -f') do
    its('stdout.chomp') { should match fqdn_pattern }
  end
end
