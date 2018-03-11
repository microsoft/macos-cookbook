resource_name :machine_name

property :hostname, String, desired_state: true, coerce: proc { |name| conform_to_rfc1034(name) }, required: true, name_property: true
property :computer_name, String, desired_state: true
property :local_hostname, String, desired_state: true, coerce: proc { |name| conform_to_rfc1034(name) }
property :netbios_name, String, desired_state: false, coerce: proc { |name| conform_to_rfc1034(name)[0, 15].upcase }
property :dns_domain, String, desired_state: false, default: ''

load_current_value do
  hostname current_hostname
  dns_domain current_dns_domain
  netbios_name shell_out('defaults', 'read', '/Library/Preferences/SystemConfiguration/com.apple.smb.server.plist', 'NetBIOSName').stdout.chomp
  computer_name get_name('ComputerName')
  local_hostname get_name('LocalHostName')
end

action :set do
  property_is_set?(:netbios_name) ? new_resource.netbios_name : new_resource.netbios_name = new_resource.hostname
  property_is_set?(:computer_name) ? new_resource.computer_name : new_resource.computer_name = new_resource.hostname
  property_is_set?(:local_hostname) ? new_resource.local_hostname : new_resource.local_hostname = new_resource.hostname

  converge_if_changed :hostname do
    converge_by 'set Hostname' do
      fqdn = [new_resource.hostname, new_resource.dns_domain].join '.'
      execute [scutil, '--set', 'HostName', fqdn] do
        notifies :reload, 'ohai[reload ohai]'
      end
    end
  end

  converge_if_changed :computer_name do
    converge_by 'set ComputerName' do
      execute [scutil, '--set', 'ComputerName', new_resource.computer_name] do
        notifies :reload, 'ohai[reload ohai]'
      end
    end
  end

  converge_if_changed :local_hostname do
    converge_by 'set LocalHostName' do
      execute [scutil, '--set', 'LocalHostName', new_resource.local_hostname] do
        notifies :reload, 'ohai[reload ohai]'
      end
    end
  end

  converge_if_changed :netbios_name do
    converge_by 'set NetBIOSName name' do
      defaults '/Library/Preferences/SystemConfiguration/com.apple.smb.server.plist' do
        settings 'NetBIOSName' => new_resource.netbios_name, 'ServerDescription' => new_resource.hostname
        notifies :restart, 'service[com.apple.cfprefsd.xpc.daemon]'
      end

      service 'com.apple.cfprefsd.xpc.daemon' do
        notifies :reload, 'ohai[reload ohai]'
        action :nothing
      end

      service 'com.apple.smb.preferences' do
        action :nothing
      end
    end
  end

  ohai 'reload ohai' do
    action :nothing
    notifies :run, 'ruby_block[sleep a while]'
  end

  ruby_block 'sleep a while' do
    block do
      sleep 60
    end
    action :nothing
  end
end
