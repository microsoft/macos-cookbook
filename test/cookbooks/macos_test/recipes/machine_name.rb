washing_machine = "New#{node['platform_version']}_Washing_Machine"

machine_name 'set computer/hostname' do
  hostname washing_machine
  computer_name washing_machine
  local_hostname washing_machine
end
