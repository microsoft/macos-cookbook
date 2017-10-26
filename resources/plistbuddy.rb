resource_name :plistbuddy

property :command, String, name_property: true

property :path, String
property :entry, String, required: true
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float]

action_class do
  def entry_exist?
    command = format_plistbuddy_command(:print, new_resource.entry, new_resource.value)
    shell_out(command).error?
  end
end

action :execute do
  if new_resource.command.to_s == 'set' && !entry_exist?
    p format_plistbuddy_command(:add, new_resource.entry)
  end
  p format_plistbuddy_command(new_resource.command, new_resource.entry, new_resource.value)
end
