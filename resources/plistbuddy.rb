resource_name :plistbuddy

property :path, String, name_property: true
property :entry, String, required: true
property :value, [Hash, String, Array, TrueClass, FalseClass, Integer, Float]

property :is_binary, [TrueClass, FalseClass]

default_action :set

action_class do
  extend MacOS::PlistBuddyHelpers

  def plistbuddy(action)
    [format_plistbuddy_command(action, new_resource.entry, new_resource.value), new_resource.path].join(' ')
  end

  def entry_missing?
    return true if shell_out(plistbuddy(:print)).error?
  end

  def needs_conversion?
    return true if shell_out('/usr/bin/file', '--brief', '--mime', new_resource.path).stdout =~ /binary/i
  end
end

load_current_value do |desired|
  full_command = [format_plistbuddy_command(:print, desired.entry), desired.path].join(' ')
  value desired.value if shell_out(full_command).stdout.chomp != desired.value
  entry desired.entry
end

action :set do
  converge_if_changed do
    plistbuddy :set
  end

  execute "add #{new_resource.entry} to #{new_resource.path}" do
    command plistbuddy :add
    only_if { entry_missing? }
  end

  execute 'convert back to binary' do
    command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    not_if { needs_conversion? }
  end
end

action :delete do
  execute "delete #{new_resource.entry} from plist" do
    command plistbuddy :delete
    not_if { entry_missing? }
  end

  execute 'convert back to binary' do
    command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    not_if { needs_conversion? }
  end
end
