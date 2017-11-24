control 'power' do
  desc 'Display, machine and hard disk never sleep, the machine automatically restarts
  after a freeze or power outage, Power Nap and screensaver are disabled'

  %w(sleep computersleep displaysleep harddisksleep).each do |setting|
    describe command("systemsetup -get#{setting}") do
      its('stdout') { should match('Never') }
    end
  end

  %w(restartfreeze remoteappleevents).each do |setting|
    describe command("systemsetup -get#{setting}") do
      its('stdout') { should match('On') }
    end
  end

  describe command('systemsetup -getwaitforstartupafterpowerfailure') do
    its('stdout') { should match('0 seconds') }
  end

  describe command('pmset -g') do
    its('stdout') { should match(/sleep\s*0/) }
    its('stdout') { should match(/hibernatemode\s*0$/) }
    its('stdout') { should match(/ttyskeepawake\s*1/) }
    its('stdout') { should match(%r{hibernatefile\s*\/var\/vm\/sleepimage}) }
    its('stdout') { should match(/disksleep\s*0/) }
    its('stdout') { should match(/displaysleep\s*0/) }
    its('stdout') { should match(/ttyskeepawake\s*1/) }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :DarkWakeBackgroundTasks' '/Library/Preferences/com.apple.PowerManagement.plist'") do
    its('stdout') { should match('false') }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :idleTime' /Users/vagrant/Library/Preferences/com.apple.screensaver.plist") do
    its('stdout') { should match(/0/) }
  end
end
