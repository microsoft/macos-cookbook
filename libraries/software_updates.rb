module MacOS
  module SoftwareUpdates
    def updates_available?
      no_new_software_pattern = Regexp.union('No new software available.')
      available_updates_command = shell_out(software_update_command, '--list', '--all')
      available_updates_command.stderr.chomp.match?(no_new_software_pattern)
    end

    def automatic_check_disabled?
      schedule_check_command = shell_out(software_update_command, '--schedule')
      schedule_check_command.stdout.chomp == 'Automatic check is off'
    end

    def software_update_command
      '/usr/sbin/softwareupdate'
    end
  end
end

Chef::DSL::Recipe.include(MacOS::SoftwareUpdates)
Chef::Resource.include(MacOS::SoftwareUpdates)
