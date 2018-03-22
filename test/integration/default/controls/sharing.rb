title 'sharing'

control 'standardized-hostname' do
  impact 0.6
  title 'macOS named with the preferred style'
  desc '
    Verify the correct values for the user-friendly name,
    the local (Bonjour) name, and the name associated with hostname
  '

  platform_and_version = [os[:name], os[:release]].join('-')
  computer_name_pattern = Regexp.union platform_and_version
  local_hostname_pattern = Regexp.union [platform_and_version, '.local'].join
  hostname_pattern = Regexp.union [platform_and_version, '.vagrantup.com'].join

  describe command('scutil --get ComputerName') do
    its('stdout') { should match computer_name_pattern }
  end

  describe command('scutil --get LocalHostName') do
    its('stdout') { should match local_hostname_pattern }
  end

  describe command('scutil --get HostName') do
    its('stdout') { should match hostname_pattern }
  end

  describe command('hostname') do
    its('stdout') { should match hostname_pattern }
  end

  describe command('hostname -s') do
    its('stdout') { should match hostname_pattern }
  end

  describe command('hostname -f') do
    its('stdout') { should match hostname_pattern }
  end
end

control 'nonstandard-computer-name' do
  impact 0.8
  title 'macOS named with an non-conventional style'
  desc '
    Verify the correct values for each of the three names are set,
    correctly, even when the name does not adhere to RFC 1034
  '

  ref 'https://tools.ietf.org/html/rfc1034'

  computer_name = "New#{os[:release]}_Washing_Machine"
  computer_name_pattern = Regexp.union computer_name
  hostname_conformed = computer_name.tr('_.', '')
  hostname_conformed_pattern = Regexp.union hostname_conformed

  describe command('scutil --get ComputerName') do
    its('stdout') { should match computer_name_pattern }
  end

  describe command('scutil --get LocalHostName') do
    its('stdout') { should match hostname_conformed_pattern }
  end

  describe command('scutil --get HostName') do
    its('stdout') { should match hostname_conformed_pattern }
  end

  describe command('hostname') do
    its('stdout') { should match hostname_conformed_pattern }
  end

  describe command('hostname -s') do
    its('stdout') { should match hostname_conformed_pattern }
  end

  describe command('hostname -f') do
    its('stdout') { should match hostname_conformed_pattern }
  end
end
