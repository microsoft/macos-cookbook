plist 'disable automatic software update downloads' do
  path '/Library/Preferences/com.apple.SoftwareUpdate.plist'
  entry 'AutomaticDownload'
  value false
end

sleep 10 if node['platform_version'].match?(/10\.11/)

plist 'disable automatic software update check' do
  path '/Library/Preferences/com.apple.SoftwareUpdate.plist'
  entry 'AutomaticCheckEnabled'
  value false
end
