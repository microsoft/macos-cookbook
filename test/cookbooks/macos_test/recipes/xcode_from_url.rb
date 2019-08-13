if mac_os_x_after_high_sierra?
  xcode 'installs 11.0' do
    download_url node['xcode']['download_url']
    version '11.0'
  end

elsif mac_os_x_high_sierra?
  xcode 'installs 10.1' do
    download_url node['xcode']['download_url']
    version '10.1'
  end
end
