module MacOS
  module SoftwareUpdates
    def updates_available?
      no_new_software_pattern = Regexp.union('No new software available.')
      command = shell_out('softwareupdate', '--list', '--all')
      command.stderr.chomp.match?(no_new_software_pattern)
    end
  end
end

Chef::Recipe.include(MacOS::SoftwareUpdates)
Chef::Resource.include(MacOS::SoftwareUpdates)
