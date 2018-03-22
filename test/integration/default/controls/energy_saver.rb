title 'energy saver'

control 'remote-administration' do
  title 'power management settings for managed macs'
  desc '
    Verify all sleep is disabled the machine automatically
    restarts after a freeze or power outage using the systemsetup and
    pmset commands
  '

  describe command('systemsetup -getremoteappleevents') do
    apple_events_pattern = Regexp.union('Remote Apple Events: On')
    its('stdout') { should match apple_events_pattern }
  end

  describe command('systemsetup -getwaitforstartupafterpowerfailure') do
    its('stdout') { should match(/0 seconds/) }
  end

  describe command('systemsetup -getremotelogin') do
    its('stdout') { should match(/On/) }
  end

  describe command('pmset -g') do
    hibernate_mode_pattern = Regexp.union('hibernatemode        0')
    its('stdout') { should match hibernate_mode_pattern }
  end

  describe command('pmset -g') do
    hibernate_pattern = Regexp.union('hibernatefile        /var/vm/sleepimage')
    its('stdout') { should match hibernate_pattern }
  end

  describe command('pmset -g') do
    ttys_awake_pattern = Regexp.union('ttyskeepawake        1')
    its('stdout') { should match ttys_awake_pattern }
  end
end

control 'no-sleep' do
  title 'macOS never goes to sleep'
  desc 'Verify that the system will not fall asleep using the pmset and systemsetup commands'

  describe command('systemsetup -getcomputersleep') do
    its('stdout') { should match(/Never/) }
  end

  describe command('systemsetup -getdisplaysleep') do
    its('stdout') { should match(/Never/) }
  end

  describe command('systemsetup -getharddisksleep') do
    its('stdout') { should match(/Never/) }
  end

  describe command('systemsetup -getrestartfreeze') do
    its('stdout') { should match(/On/) }
  end

  describe command('pmset -g') do
    no_sleep_pattern = Regexp.union('sleep                0')
    its('stdout') { should match no_sleep_pattern }
  end

  describe command('pmset -g') do
    disk_sleep_pattern = Regexp.union('disksleep            0')
    its('stdout') { should match disk_sleep_pattern }
  end

  describe command('pmset -g') do
    display_sleep_pattern = Regexp.union('displaysleep         0')
    its('stdout') { should match display_sleep_pattern }
  end
end

# the 'DarkWakeBackgroundTasks' key changes namespaces depending on the hardware
# the location of the com.apple.PowerManagement.plist plist is also different depending on the OS version
# also, if sleep is disabled, why does this matter?
control 'disable-powernap', :skip do
  title 'do not perform useful activities while macOS is asleep'
  desc 'Verify powernap is disabled using pmset output'

  power_management_plist = if os[:release].match? Regexp.union ['10.12', '10.13']
                             '/Library/Preferences/com.apple.PowerManagement.plist'
                           else
                             '/Library/Preferences/SystemConfiguration/com.apple.PowerManagement.plist'
                           end

  describe command("/usr/libexec/PlistBuddy -c 'Print :DarkWakeBackgroundTasks' #{power_management_plist}"), :skip do
    its('stdout') { should match(/false/) }
  end
end
