system_preference 'disable computer sleep' do
  preference :computersleep
  setting 'Never'
end

system_preference 'disable display sleep' do
  preference :displaysleep
  setting 'Never'
end

system_preference 'disable hard disk sleep' do
  preference :harddisksleep
  setting 'Never'
  only_if { node['macos']['hard_disk_sleep'] }
end

system_preference 'restart if the computer becomes unresponsive' do
  preference :restartfreeze
  setting 'On'
end

system_preference 'wake the computer when accessed using a network connection' do
  preference :wakeonnetworkaccess
  setting 'On'
  not_if { running_in_a_vm? }
end

system_preference 'restart after a power failure' do
  preference :restartpowerfailure
  setting 'On'
  not_if { running_in_a_vm? }
end

system_preference 'pressing power button does not sleep computer' do
  preference :allowpowerbuttontosleepcomputer
  setting 'Never'
  only_if { power_button_model? }
end

system_preference 'allow remote apple events' do
  preference :remoteappleevents
  setting 'On'
end

system_preference 'set the network time server' do
  preference :networktimeserver
  setting node['macos']['network_time_server']
end

system_preference 'set the time zone' do
  preference :timezone
  setting node['macos']['time_zone']
end

system_preference 'enable remote login' do
  preference :remotelogin
  setting 'On'
  only_if { node['macos']['remote_login'] }
end

defaults 'com.apple.screensaver' do
  option '-currentHost write'
  settings 'idleTime' => 0
  not_if { screensaver_disabled? }
  user node['macos']['admin_user']
end
