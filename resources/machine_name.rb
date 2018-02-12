resource_name :machine_name

property :hostname, String, desired_state: true, coerce: proc { |name| conform_to_rfc1034(name) }, required: true, name_property: true
property :computer_name, String, desired_state: true
property :local_hostname, String, desired_state: true, coerce: proc { |name| conform_to_rfc1034(name) }
property :netbios_name, String, desired_state: false, coerce: proc { |name| conform_to_rfc1034(name)[0, 15].upcase }

load_current_value do
  hostname get_name('HostName')
  computer_name get_name('ComputerName')
  local_hostname get_name('LocalHostName')
end

action :set do
  converge_if_changed :hostname do
    converge_by "set Hostname to #{new_resource.hostname}" do
      execute [scutil, '--set', 'HostName', new_resource.hostname] do
        notifies :reload, 'ohai[reload ohai]'
      end
    end
  end

  converge_if_changed :computer_name do
    property_is_set?(:computer_name) ? new_resource.computer_name : new_resource.computer_name = new_resource.hostname.split('.').first
    converge_by "set ComputerName to #{new_resource.computer_name}" do
      execute [scutil, '--set', 'ComputerName', new_resource.computer_name] do
        notifies :reload, 'ohai[reload ohai]'
      end
    end
  end

  converge_if_changed :local_hostname do
    property_is_set?(:local_hostname) ? new_resource.local_hostname : new_resource.local_hostname = new_resource.hostname.split('.').first
    converge_by "set LocalHostName to #{new_resource.local_hostname}" do
      execute [scutil, '--set', 'LocalHostName', new_resource.local_hostname] do
        notifies :reload, 'ohai[reload ohai]'
      end
    end
  end

  property_is_set?(:netbios_name) ? new_resource.netbios_name : new_resource.netbios_name = new_resource.hostname.split('.').first
  plist 'netbios name' do # converge_if_changed is not needed since `plist` is already idempotent
    path '/Library/Preferences/SystemConfiguration/com.apple.smb.server.plist'
    entry 'NetBIOSName'
    value new_resource.netbios_name
    notifies :restart, 'service[com.apple.smbd]'
    notifies :reload, 'ohai[reload ohai]'
  end

  service 'com.apple.smbd' do
    action :nothing
  end

  ohai 'reload ohai' do
    action :nothing
  end
end
