if node['platform_version'] >= '10.15.6'
  xcode '12.0' do
    apple_id({ username: ENV['APPLEID_USERNAME'], password: ENV['APPLEID_PASSWORD'] })
  end
else
  xcode '10.2.1' do
    ios_simulators ['12', '11']
    apple_id({ username: ENV['APPLEID_USERNAME'], password:  ENV['APPLEID_PASSWORD'] })
  end
end
