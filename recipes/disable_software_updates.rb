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

execute 'disable software updates using commandline utility' do
  command [software_update_command, '--schedule', 'off']
  not_if { automatic_check_disabled? }
end
