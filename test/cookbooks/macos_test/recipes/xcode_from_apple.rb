if node['platform_version'] >= '10.14.4'
  xcode '11.5'
else
  xcode '9.4.1' do
    ios_simulators %w(11 10)
  end
end
