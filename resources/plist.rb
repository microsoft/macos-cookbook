resource_name :plist

property :path, String, name_property: true, desired_state: true
property :entry, String, desired_state: true
property :value, [TrueClass, FalseClass, String, Integer, Float, Array], desired_state: true
property :binary, [TrueClass, FalseClass], desired_state: true, default: true

load_current_value do |desired|
  current_value_does_not_exist! unless ::File.exist?(desired.path)
  contents = convert_to_hash desired.path
  entry desired.entry if contents.key? desired.entry
  value contents[desired.entry]
  binary shell_out('/usr/bin/file', '--brief', '--mime-encoding', desired.path).stdout.chomp == 'binary'
end

action :set do
  plist_entry = PlistBuddy.new new_resource.entry, new_resource.path

  converge_if_changed :path do
    converge_by "creating \"#{new_resource.path}\"" do
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

  converge_if_changed :entry do
    converge_by "adding entry \"#{new_resource.entry}\" to #{new_resource.path.split('/').last}" do
      execute plist_entry.add new_resource.value
    end
  end

  converge_if_changed :value do
    converge_by "#{new_resource.path.split('/').last}: set #{new_resource.entry} to #{new_resource.value}" do
      execute plist_entry.set new_resource.value
    end
  end

  converge_if_changed :binary do
    converge_by "convert \"#{new_resource.path.split('/').last}\" to binary" do
      execute "convert #{new_resource.path} to binary format" do
        command [plutil_executable, '-convert', 'binary1', new_resource.path]
      end
    end
  end
end

action_class do
  def binary?
    file_type_output = shell_out('/usr/bin/file', '--brief', '--mime-encoding', new_resource.path).stdout
    file_type_output.chomp == 'binary'
  end

  def convert_to_binary(_path)
    execute ['/usr/bin/plutil', '-convert', 'binary1', new_resource.path]
  end
end
