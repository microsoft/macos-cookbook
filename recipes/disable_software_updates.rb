plist 'disable automatic software update check' do
  path '/Library/Preferences/com.apple.SoftwareUpdate.plist'
  entry 'AutomaticCheckEnabled'
  value false
end

plist 'disable automatic software update downloads' do
  path '/Library/Preferences/com.apple.SoftwareUpdate.plist'
  entry 'AutomaticDownload'
  value false
end
