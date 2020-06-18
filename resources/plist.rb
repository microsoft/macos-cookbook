provides :plist

property :path, String, name_property: true
property :entry, String
property :value, [TrueClass, FalseClass, String, Integer, Float, Hash]
property :encoding, String, default: 'binary'
property :owner, String, default: 'root'
property :group, String, default: 'wheel'
property :mode, [String, Integer]

load_current_value do |desired|
  current_value_does_not_exist! unless ::File.exist? desired.path
  entry desired.entry if entry_in_plist? desired.entry, desired.path

  setting = setting_from_plist desired.entry, desired.path
  value convert_to_data_type_from_string(setting[:key_type], setting[:key_value])

  file_type_cmd = shell_out '/usr/bin/file', '--brief', '--mime-encoding', '--preserve-date', desired.path
  encoding file_type_cmd.stdout.chomp

  file_owner_cmd = shell_out('/usr/bin/stat', '-f', '%Su', desired.path)
  owner file_owner_cmd.stdout.chomp

  file_group_cmd = shell_out('/usr/bin/stat', '-f', '%Sg', desired.path)
  group file_group_cmd.stdout.chomp
end

action :set do
  converge_if_changed :path do
    converge_by "create new plist: '#{new_resource.path}'" do
      file new_resource.path do
        empty_plist = {}.to_plist
        content empty_plist
        owner new_resource.owner
        group new_resource.group
        mode new_resource.mode if property_is_set?(:mode)
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
      raise("Option encoding must be equal to one of: #{plutil_format_map.keys}!  You passed \"#{new_resource.encoding}\".") unless plutil_format_map.key?(new_resource.encoding)
      execute [plutil_executable, '-convert', plutil_format_map[new_resource.encoding], new_resource.path] do
        action :run
      end
    end
  end

  converge_if_changed :owner do
    converge_by "update owner to #{new_resource.owner}" do
      file new_resource.path do
        owner new_resource.owner
      end
    end
  end

  converge_if_changed :group do
    converge_by "update group to #{new_resource.group}" do
      file new_resource.path do
        group new_resource.group
      end
    end
  end
end
