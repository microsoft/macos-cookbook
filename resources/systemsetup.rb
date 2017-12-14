require 'colorize'

resource_name :systemsetup

property :setting, desired_state: false
property :value, desired_state: true, coerce: proc { |m| m.to_s }

default_action :set

load_current_value do |desired|
  command_output = shell_out('/usr/sbin/systemsetup', "-get#{desired.setting}").stdout.split(': ').last.strip
  if command_output.include?('after')
    value command_output.split[1]
  elsif command_output.end_with?('seconds')
    value command_output.split.first
  elsif command_output.start_with?('Error')
    puts "\n"
    warn(command_output.to_s.colorize(:red).bold)
    warn(desired.setting.to_s.colorize(:red))
    value desired.value
  else
    value command_output.split.last
  end
end

action :set do
  converge_if_changed do
    converge_by "set #{new_resource.setting} to #{new_resource.value}" do
      execute "/usr/sbin/systemsetup -set#{new_resource.setting} #{new_resource.value}"
    end
  end
end
