if node['platform_version'] >= '10.14.4'
  xcode 'installs 11.0' do
    download_url node['xcode']['download_url']
    version '11.0'
  end
else
  xcode 'installs 9.4.1' do
    download_url node['xcode']['download_url']
    version '9.4.1'
  end
end
