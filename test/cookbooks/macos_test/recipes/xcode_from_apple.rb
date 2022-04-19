if node['platform_version'] >= '10.15.6'
  xcode '12.0' do
    apple_id({ username: ::File.read('/Users/vagrant/username'), password: ::File.read('/Users/vagrant/password') })
  end
else
  xcode '10.2.1' do
    ios_simulators ['12', '11']
    apple_id({ username: ::File.read('/Users/vagrant/username'), password: ::File.read('/Users/vagrant/password') })
  end
end
