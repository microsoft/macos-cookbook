plist 'disable Power Nap' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'DarkWakeBackgroundTasks'
  value false
end

plist 'enable automatic restart on power loss' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'Automatic Restart On Power Loss'
  value true
end

plist 'set display sleep timer to zero' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'Display Sleep Timer'
  value 0
end

plist 'enable wake from sleep via network' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'Wake On LAN'
  value true
end

plist 'set system sleep timer to zero' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'System Sleep Timer'
  value 0
end

plist 'disable screensaver' do
  path "/Users/#{node['macos']['admin_user']}/Library/Preferences/ByHost/com.apple.screensaver.#{hardware_uuid}.plist"
  entry 'idleTime'
  value 0
end

systemsetup 'Set amount of idle time until computer sleeps to never' do
  setting 'computersleep'
  value 'Never'
end

systemsetup 'set amount of idle time until display sleeps to never' do
  setting 'displaysleep'
  value 'Never'
end

systemsetup 'set amount of idle time until hard disk sleeps to never' do
  setting 'harddisksleep'
  value 'Never'
end

systemsetup 'set remote apple events to on' do
  setting 'remoteappleevents'
  value 'On'
end

systemsetup 'disable the power button from being able to sleep the computer.' do
  setting 'allowpowerbuttontosleepcomputer'
  value 'Off'
end

systemsetup 'set the number of seconds after which the computer will start up after a power failure to zero.' do
  setting 'waitforstartupafterpowerfailure'
  value 0
end

systemsetup 'set restart on freeze to on' do
  setting 'restartfreeze'
  value 'On'
end

systemsetup "set network time server to #{node['macos']['network_time_server']}" do
  setting 'networktimeserver'
  value node['macos']['network_time_server']
end

systemsetup "set current time zone to #{node['macos']['time_zone']}" do
  setting 'timezone'
  value node['macos']['time_zone']
end
