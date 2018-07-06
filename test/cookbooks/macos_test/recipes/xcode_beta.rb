execute 'Disable Gatekeeper' do
  command ['spctl', '--master-disable']
end

xcode '10.0' if node['platform_version'].match? Regexp.union '10.13'
