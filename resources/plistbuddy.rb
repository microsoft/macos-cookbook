resource_name :plistbuddy

property :path, String, name_property: true
property :entry, String, required: true
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float]

default_action :set

action_class do
  def entry_missing?
    command = format_plistbuddy_command(:print, new_resource.entry, new_resource.value)
    full_command = command + ' ' + new_resource.path
    shell_out(full_command).error?
  end

  def current_entry_value
    command = format_plistbuddy_command(:print, new_resource.entry)
    full_command = command + ' ' + new_resource.path
    shell_out(full_command).stdout.chomp
  end
end

action :set do
  if entry_missing?
    execute format_plistbuddy_command(:add, new_resource.entry, new_resource.value) + ' ' + new_resource.path
    execute format_plistbuddy_command(:set, new_resource.entry, new_resource.value) + ' ' + new_resource.path
  elsif current_entry_value != new_resource.value.to_s
    execute format_plistbuddy_command(:set, new_resource.entry, new_resource.value) + ' ' + new_resource.path
  end
end

action :delete do
  execute format_plistbuddy_command(:delete, new_resource.entry, new_resource.value) + ' ' + new_resource.path
end
