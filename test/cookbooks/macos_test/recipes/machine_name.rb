name = "New#{node['platform_version']}_Washing_Machine"

machine_name name do
  not_if { shell_out('scutil', '--get', 'HostName').stdout.match? Regexp.union name }
end
