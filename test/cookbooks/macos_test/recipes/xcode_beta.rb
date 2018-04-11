execute 'Disable Gatekeeper' do
  command ['spctl', '--master-disable']
end

xcode '9.4' if node['platform_version'].match? Regexp.union '10.13'
