resource_name :plistbuddy

property :path, String, name_property: true
property :entry, String, required: true, desired_state: false
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float], desired_state: true

property :is_binary, [TrueClass, FalseClass]

default_action :set

action_class do
  extend MacOS::PlistBuddyHelpers

  def plistbuddy(action)
    [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  end

  def entry_exist?
    return true unless shell_out(plistbuddy(:print)).error?
  end

  def current_plist_entry_value
    type = shell_out('/usr/bin/defaults', 'read-type', new_resource.path, new_resource.entry).split.last
    value = shell_out('/usr/bin/defaults', 'read', new_resource.path, new_resource.entry)
    convert_to_data_type_from_string(type, value)
  end

  def needs_conversion?
    return true if shell_out('/usr/bin/file', '--brief', '--mime', new_resource.path).stdout =~ /binary/i
  end
end

# load_current_value do
#   value
# end

action :set do
  converge_if_changed do
    plistbuddy :set
  end

  execute "add #{new_resource.entry} to #{new_resource.path}" do
    command plistbuddy :add
    not_if { entry_exist? }
  end

  execute 'convert back to binary' do
    command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    not_if { needs_conversion? }
  end
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command plistbuddy :delete
    only_if { entry_exist? }
  end

  execute 'convert back to binary' do
    command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    not_if { needs_conversion? }
  end
end
