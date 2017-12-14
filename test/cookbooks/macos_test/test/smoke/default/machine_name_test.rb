control 'machine name' do
  desc 'machine name is set to the format "New#{macos_semantic_version}_Washing_Machine"'

  macos_semantic_version = command('sw_vers -productVersion').stdout.strip
  hostname_pattern = /New#{macos_semantic_version}_Washing_Machine/

  hostname_commands = ['hostname',
                       'scutil --get ComputerName',
                       'scutil --get HostName']

  hostname_commands.each do |hostname_command|
    describe command(hostname_command) do
      its('stdout') { should match hostname_pattern }
    end
  end
end
