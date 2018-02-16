resource_name :plist

property :path, String, name_property: true, desired_state: true
property :entry, String, desired_state: true
property :value, [TrueClass, FalseClass, String, Integer, Float], desired_state: true

load_current_value do |desired|
  setting = setting_from_plist(desired.path, desired.entry)

  current_value_does_not_exist! unless ::File.exist?(desired.path)
  entry plistbuddy_command(:print, desired.entry, new_resource.entry)
  value convert_to_data_type_from_string(setting[:key_type], setting[:key_value])
end

action :set do
  converge_if_changed :path do
    converge_by "creating \"#{new_resource.path}\"" do
      file new_resource.path do
        content <<~EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        </dict>
        </plist>
        EOF
      end
    end
  end

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
      execute ['/usr/bin/plutil', '-convert', 'binary1', new_resource.path]
    end
  end
end

action_class do
  def binary?
    file_type_output = shell_out('/usr/bin/file', '--brief', '--mime-encoding', new_resource.path).stdout
    file_type_output.chomp == 'binary'
  end

  def convert_to_binary(path)
    execute ['/usr/bin/plutil', '-convert', 'binary1', new_resource.path]
  end
end
