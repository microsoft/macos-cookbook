resource_name :plist

property :path, String, name_property: true, desired_state: true
property :entry, String, desired_state: true
property :value, [TrueClass, FalseClass, String, Integer, Float], desired_state: true
property :encoding, String, desired_state: true, default: 'binary', equal_to: plutil_format_map.keys

load_current_value do |desired|
  current_value_does_not_exist! unless ::File.exist? desired.path
  entry desired.entry if print_entry_value desired.entry, desired.path

  setting = setting_from_plist desired.entry, desired.path
  value convert_to_data_type_from_string(setting[:key_type], setting[:key_value])

  file_type_cmd = shell_out '/usr/bin/file', '--brief', '--mime-encoding', '--preserve-date', desired.path
  encoding file_type_cmd.stdout.chomp
end

action :set do
  converge_if_changed :path do
    converge_by "create new plist: '#{new_resource.path}'" do
      file new_resource.path do
        content <<-EOF
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

  plist_file_name = new_resource.path.split('/').last

  converge_if_changed :entry do
    converge_by "add entry \"#{new_resource.entry}\" to #{plist_file_name}" do
      execute plistbuddy_command(:add, new_resource.entry, new_resource.path, new_resource.value) do
        action :run
      end
    end
  end

  converge_if_changed :value do
    converge_by "#{plist_file_name}: set #{new_resource.entry} to #{new_resource.value}" do
      execute plistbuddy_command(:set, new_resource.entry, new_resource.path, new_resource.value) do
        action :run
      end
    end
  end

  converge_if_changed :encoding do
    converge_by 'change format' do
      execute ['/usr/bin/plutil', '-convert', plutil_format_map[new_resource.encoding], new_resource.path] do
        action :run
      end
    end
  end
end
