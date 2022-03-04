if node['platform_version'] >= '10.15.2'
  xcode '11.5'
else
  xcode '9.4.1' do
    ios_simulators ['11', '10']
  end
end
