if node['platform_version'] >= '10.15.2'
  xcode '11.5' do
    apple_id({ username: APPLEID_USERNAME, password: APPLEID_PASSWORD })
  end
else
  xcode '9.4.1' do
    ios_simulators ['11', '10']
    apple_id({ username: APPLEID_USERNAME, password: APPLEID_PASSWORD })
  end
end
