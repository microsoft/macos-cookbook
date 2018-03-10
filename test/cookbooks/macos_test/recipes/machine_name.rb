washing_machine_name = 'New' + node['platform_version'] + '_Washing_Machine'

machine_name 'set computer/hostname' do
  hostname washing_machine_name
  computer_name washing_machine_name
  local_hostname washing_machine_name
  domainname 'body-of-swirling-water.com'
end
