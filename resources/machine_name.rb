resource_name :machine_name

deprecated 'The `machine_name` resource is deprecated, and will be removed in the release of v3.0 of the macOS cookbook.'

property :hostname, String, desired_state: true, coerce: proc { |name| conform_to_dns_standards(name) }, name_property: true
property :computer_name, String, desired_state: true
property :local_hostname, String, desired_state: true, coerce: proc { |name| conform_to_dns_standards(name) }
property :dns_domain, String, desired_state: false

load_current_value do
  hostname current_hostname
  dns_domain current_dns_domain
  computer_name get_name('ComputerName')
  local_hostname get_name('LocalHostName')
end

action :set do
  new_resource.property_is_set?(:computer_name) ? new_resource.computer_name : new_resource.computer_name = new_resource.hostname
  new_resource.property_is_set?(:local_hostname) ? new_resource.local_hostname : new_resource.local_hostname = new_resource.hostname

  converge_if_changed :hostname do
    converge_by 'set Hostname' do
      fqdn = new_resource.property_is_set?(:dns_domain) ? [new_resource.hostname, new_resource.dns_domain].join('.') : new_resource.hostname
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

  ohai 'reload ohai' do
    action :nothing
  end
end
