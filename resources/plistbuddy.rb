resource_name :plistbuddy

property :binary, [TrueClass, FalseClass], default: true, desired_state: true
property :entry, String, required: true, desired_state: false
property :path, String, name_property: true, desired_state: false
property :value, [String, TrueClass, FalseClass, Integer, Float, nil], desired_state: true

default_action :set

load_current_value do |desired|
  value_from_system = shell_out('/usr/bin/defaults', 'read', desired.path, desired.entry).stdout.strip
  current_value_does_not_exist! if value_from_system.nil?
  entry_type_from_system = shell_out('/usr/bin/defaults', 'read-type', desired.path, desired.entry).stdout.split.last
  value convert_to_data_type_from_string(entry_type_from_system, value_from_system)
  binary true if shell_out('/usr/bin/file', '--brief', '--mime', desired.path).stdout =~ /binary/i
end

action :set do
  converge_if_changed :value do
    converge_by "add \"#{new_resource.entry}\" to #{new_resource.path.split('/').last}" do
      execute plistbuddy_command :add, new_resource.entry, new_resource.path, new_resource.value do
        not_if plistbuddy_command :print, new_resource.entry, new_resource.path
      end
    end

    converge_by "set \"#{new_resource.entry}\" to #{new_resource.value} at #{new_resource.path.split('/').last}" do
      execute plistbuddy_command :set, new_resource.entry, new_resource.path, new_resource.value
    end
  end

  unless new_resource.binary == false
    converge_if_changed :binary do
      converge_by "convert \"#{new_resource.path.split('/').last}\" to binary plist" do
        execute "/usr/bin/plutil -convert binary1 #{new_resource.path}"
      end
    end
  end
end
