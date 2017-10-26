resource_name :plistbuddy

property :action, Symbol, name_property: true

property :name, String
property :entry, String, required: true
property :value, [Hash, String, Array, TrueClass, FalseClass, Int, Float]

action_class do
  def entry_exists?
    command = format_plistbuddy_command(:print, new_resource.entry, new_resource.value)
    shell_out(command).error?
  end
end

action :execute do
  if new_resource.action == :set && !entry_exist?
    format_plistbuddy_command(:add, new_resource.entry)
  end
  format_plistbuddy_command(new_resource.action, new_resource.entry, new_resource.value)
end
