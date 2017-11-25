resource_name :plistbuddy

property :path, String, name_property: true
property :entry, String, required: true
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float]

property :is_binary, [TrueClass, FalseClass]

default_action :set

action_class do
  def entry_missing?
    full_command = [format_plistbuddy_command(:print, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    shell_out(full_command).error?
  end

  def current_entry_value
    full_command = [format_plistbuddy_command(:print, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    shell_out(full_command).stdout.chomp
  end

  def binary_plist?
    file_output = shell_out('/usr/bin/file', '--brief', '--mime', new_resource.path)
    return true if file_output.stdout =~ /binary/
  end
end

load_current_value do
  if binary_plist?
    is_binary true
  else
    is_binary false
  end
end

action :set do
  execute "add #{new_resource.entry} to #{new_resource.path}" do
    command [format_plistbuddy_command(:add, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    only_if { entry_missing? }
  end

  execute "set #{new_resource.entry} to #{new_resource.value}" do
    command [format_plistbuddy_command(:set, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    only_if { current_entry_value != new_resource.value.to_s }
  end

  execute 'convert back to binary' do
    command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    only_if { new_resource.is_binary }
  end
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command [format_plistbuddy_command(:delete, new_resource.entry, new_resource.value), new_resource.path].join(' ')
    not_if { entry_missing? }
  end

  execute 'convert back to binary' do
    command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    only_if { new_resource.is_binary }
  end
end
