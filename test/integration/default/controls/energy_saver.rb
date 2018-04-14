title 'energy saver'

control 'remote-administration' do
  title 'power management settings for managed macs'
  desc '
    Verify all sleep is disabled the machine automatically
    restarts after a freeze or power outage using the systemsetup and
    pmset commands
  '

  describe command('systemsetup -getremoteappleevents') do
    its('stdout') { should include 'Remote Apple Events: On' }
  end

  describe command('systemsetup -getwaitforstartupafterpowerfailure') do
    its('stdout') { should match(/getwaitforstartupafterpowerfailure: 0 seconds/) }
  end

  describe command('systemsetup -getremotelogin') do
    its('stdout') { should match(/On/) }
  end

  describe command('pmset -g') do
    its('stdout') { should match(/hibernatemode\s+0/) }
  end

  describe command('pmset -g') do
    its('stdout') { should match %r{hibernatefile\s+/var/vm/sleepimage} }
  end

  describe command('pmset -g') do
    its('stdout') { should match(/ttyskeepawake\s+1/) }
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
    its('stdout') { should match(/sleep\s+0/) }
  end

  describe command('pmset -g') do
    its('stdout') { should match(/disksleep\s+0/) }
  end

  describe command('pmset -g') do
    its('stdout') { should match(/displaysleep\s+0/) }
  end
end
