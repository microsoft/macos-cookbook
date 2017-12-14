resource_name :plist

property :path, String, name_property: true
property :entry, String, desired_state: true
property :value, [TrueClass, FalseClass, String, Integer, Float], desired_state: true

action_class do
  def binary?
    file_type_output = shell_out('/usr/bin/file', '--brief', '--mime-encoding', new_resource.path).stdout
    file_type_output.strip == 'binary'
  end
end

load_current_value do |desired|
  system_preference = system_preference(desired.path, desired.entry)
  current_value_does_not_exist! if system_preference[:key_type].nil?
  entry desired.entry unless system_preference[:key_type].nil?
  value convert_to_data_type_from_string(system_preference[:key_type], system_preference[:key_value])
end

action :set do
  converge_if_changed :entry do
    converge_by "add \"#{new_resource.entry}\" to #{new_resource.path.split('/').last}" do
      execute plistbuddy_command(:add, new_resource.entry, new_resource.path, new_resource.value)
    end
  end

  converge_if_changed :value do
    converge_by "set \"#{new_resource.entry}\" to #{new_resource.value} at #{new_resource.path.split('/').last}" do
      execute plistbuddy_command(:set, new_resource.entry, new_resource.path, new_resource.value)
    end
  end

  unless binary?
    converge_by "convert \"#{new_resource.path.split('/').last}\" to binary" do
      execute "/usr/bin/plutil -convert binary1 #{new_resource.path}"
    end
  end
end
