remote_management 'activate and configure remote management for all users' do
  action :enable
  not_if { node['platform_version'] >= '11.0' } # remove prior to Big Sur public release
end
