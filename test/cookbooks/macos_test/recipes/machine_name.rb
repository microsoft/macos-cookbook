washing_machine_name = 'New' + node['platform_version'] + '_Washing_Machine'

execute 'setting hostname to nil' do
  command 'sudo scutil --set HostName'
end

machine_name 'set computer/hostname' do
  hostname washing_machine_name
  computer_name washing_machine_name
  local_hostname washing_machine_name
  dns_domain 'body-of-swirling-water.com'
end
