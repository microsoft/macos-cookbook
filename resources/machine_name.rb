resource_name :machine_name
default_action :run

BASE_COMMAND = '/usr/sbin/scutil'.freeze
SMB_SERVER_PLIST = '/Library/Preferences/SystemConfiguration/com.apple.smb.server'.freeze

property :machine_name, String, name_property: true

# We cannot set the LocalHostName here because it does not conform to
# the DNS standards outlined in RFC 1034 (section 3.5)

action :run do
  execute BASE_COMMAND do
    command "#{BASE_COMMAND} --set HostName '#{new_resource.machine_name}'"
  end

  execute BASE_COMMAND do
    command "#{BASE_COMMAND} --set ComputerName '#{new_resource.machine_name}'"
  end

  defaults SMB_SERVER_PLIST do
    settings 'NetBIOSName' => new_resource.machine_name
  end
end
