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

defaults '/Library/Preferences/com.apple.PowerManagement' do
  settings 'DarkWakeBackgroundTasks' => false, # power nap
           '"Automatic Restart On Power Loss"' => true,
           '"Display Sleep Timer"' => 0,
           '"Disk Sleep Timer"' => 0,
           '"Wake On LAN"' => true,
           '"System Sleep Timer"' => 0
end

execute 'defaults -currentHost write com.apple.screensaver idleTime 0' do
  user node['macos']['admin_user']
end
