form_factor = MacOS::System::FormFactor.new()
env = MacOS::System::Environment.new()
scr_svr = MacOS::System::ScreenSaver.new()

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
end

system_preference 'restart if the computer becomes unresponsive' do
  preference :restartfreeze
  setting 'On'
end

system_preference 'wake the computer when accessed using a network connection' do
  preference :wakeonnetworkaccess
  setting 'On'
  not_if { env.vm? }
end

system_preference 'restart after a power failure' do
  preference :restartpowerfailure
  setting 'On'
  not_if { env.vm? }
end

system_preference 'pressing power button does not sleep computer' do
  preference :allowpowerbuttontosleepcomputer
  setting 'Off'
  only_if { form_factor.desktop? }
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
  if node['macos']['remote_login_enabled']
    setting 'On'
  else
    setting 'Off'
  end
end

defaults 'com.apple.screensaver' do
  option '-currentHost write'
  settings 'idleTime' => 0
  not_if { scr_svr.disabled? }
  user node['macos']['admin_user']
end
