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
  execute "add #{new_resource.entry} to #{new_resource.path}" do
    command [format_plistbuddy_command(:add, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    only_if { entry_missing? }
  end

  execute "set #{new_resource.value} at #{new_resource.entry}" do
    command [format_plistbuddy_command(:set, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    only_if { current_entry_value != new_resource.value.to_s }
  end
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command [format_plistbuddy_command(:delete, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    not_if { entry_missing? }
  end
end
