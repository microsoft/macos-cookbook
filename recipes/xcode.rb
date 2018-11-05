if mac_os_x_after_sierra?
  execute 'Disable Gatekeeper' do
    command ['spctl', '--master-disable']
  end

  xcode node['macos']['xcode']['version']

elsif mac_os_x_sierra?
  execute 'Disable Gatekeeper' do
    command ['spctl', '--master-disable']
  end

  xcode '9.2' do
    ios_simulators %w(11 10)
  end

elsif node['platform_version'].match? Regexp.union '10.11'
  xcode '8.2.1' do
    ios_simulators %w(10 9)
  end
end
