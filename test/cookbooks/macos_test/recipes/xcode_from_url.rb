if node['platform_version'] >= '10.15.6'
  xcode 'installs 12.0' do
    download_url ::File.read('/Users/vagrant/xcode')
    version '12.0'
  end
else
  xcode 'installs 10.2.1' do
    download_url ::File.read('/Users/vagrant/xcode')
    version '10.2.1'
  end
end
