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

elsif mac_os_x_el_capitan?
  xcode '8.2.1' do
    ios_simulators %w(10 9)
  end

else
  raise "#{node['platform_version']} is not supported."
end
