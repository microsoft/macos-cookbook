resource_name :plistbuddy

property :path, String, name_property: true, desired_state: false
property :entry, String, required: true, desired_state: false
property :value, [String, TrueClass, FalseClass, Integer, Float, nil], desired_state: true
property :binary, [TrueClass, FalseClass], desired_state: true

default_action :set

action_class do
  require 'colorize'

  def binary?
    return true if shell_out('/usr/bin/file', '--brief', '--mime', new_resource.path).stdout =~ /binary/i
  end
end

load_current_value do |desired|
  value_from_system = shell_out('/usr/bin/defaults', 'read', desired.path, desired.entry).stdout.strip
  current_value_does_not_exist! if value_from_system.nil?
  entry_type_from_system = shell_out('/usr/bin/defaults', 'read-type', desired.path, desired.entry).stdout.split.last
  value convert_to_data_type_from_string(entry_type_from_system, value_from_system)
end

action :set do
  converge_if_changed :value do
    converge_by "add \"#{new_resource.entry}\" to #{new_resource.path.split('/').last}" do
      execute plistbuddy_command('add', new_resource.entry, new_resource.path, new_resource.value) do
        not_if plistbuddy_command('print', new_resource.entry, new_resource.path)
      end
    end

    converge_by "set \"#{new_resource.entry}\" to #{new_resource.value} at #{new_resource.path.split('/').last}" do
      execute plistbuddy_command('set', new_resource.entry, new_resource.path, new_resource.value)
    end
  end
end

# execute 'convert back to binary' do
#   command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
#   not_if { needs_conversion? }
# end

# action :delete do
# execute "delete #{new_resource.entry} from plist" do
#   command plistbuddy :delete
#   only_if { entry_exist? }
# end

# execute 'convert back to binary' do
#   command "/usr/bin/plutil -convert binary1 #{new_resource.path}"
#   not_if { needs_conversion? }
# end
# end
