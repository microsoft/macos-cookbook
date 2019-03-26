if mac_os_x_after_sierra?
  xcode 'installs 10.1' do
    download_url node['xcode']['download_url']
    version '10.1'
  end

elsif mac_os_x_sierra?
  xcode 'installs 10.1' do
    download_url node['xcode']['download_url']
    version '9.2'
  end
end
