if node['platform_version'].match? Regexp.union /10.14|10.13/
  execute 'Disable Gatekeeper' do
    command ['spctl', '--master-disable']
  end

  xcode node['macos']['xcode']['version']

elsif node['platform_version'].match? Regexp.union '10.12'
  execute 'Disable Gatekeeper' do
    command ['spctl', '--master-disable']
  end

  xcode '9.2' do
    ios_simulators %w(11 10)
  end
end
