systemsetup 'keep awake and set time with systemsetup' do
  set sleep: 0,
      computersleep: 0,
      displaysleep: 0,
      harddisksleep: 0,
      remoteappleevents: 'On',
      allowpowerbuttontosleepcomputer: 'Off',
      waitforstartupafterpowerfailure: 0,
      restartfreeze: 'On',
      networktimeserver: 'time.windows.com',
      timezone: 'America/Los_Angeles'
end

pmset 'keep awake with /usr/bin/pmset' do
  settings sleep: 0,
           hibernatemode: 0,
           womp: 1, # wake on ethernet magic packet
           hibernatefile: '/var/vm/sleepimage',
           ttyskeepawake: 1
end

plistbuddy 'disable Power Nap' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'DarkWakeBackgroundTasks'
  value false
end

plistbuddy 'enable automatic restart on power loss' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'Automatic Restart On Power Loss'
  value true
end

plistbuddy 'set display sleep timer to zero' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'Display Sleep Timer'
  value 0
end

plistbuddy 'enable wake from sleep via network' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'Wake On LAN'
  value true
end

plistbuddy 'set system sleep timer to zero' do
  path '/Library/Preferences/com.apple.PowerManagement.plist'
  entry 'System Sleep Timer'
  value 0
end

ruby_block 'set power settings to autoLoginUser' do
  block do
    loginwindow_plist = '/Library/Preferences/com.apple.loginwindow'
    auto_login_user = "defaults read #{loginwindow_plist} autoLoginUser"
    node.default['macos']['power']['owner'] = shell_out!(auto_login_user).stdout.strip
  end
end

execute 'disable screensaver' do
  command lazy { "sudo -u #{node['macos']['power']['owner']} defaults -currentHost write com.apple.screensaver idleTime 0" }
end
