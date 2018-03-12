control 'power' do
  desc 'Computer sleep and display sleep are disabled, the machine automatically restarts
  after a freeze or power outage, and Power Nap is disabled'

  %w(sleep computersleep displaysleep).each do |setting|
    describe command("systemsetup -get#{setting}") do
      its('stdout') { should match('Never') }
    end
  end

  describe command('systemsetup -getharddisksleep') do
    its('stdout') { should match('Hard Disk Sleep: after 10 minutes') }
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
    its('stdout') { should match(/disksleep\s*10/) }
    its('stdout') { should match(/displaysleep\s*0/) }
  end
end

control 'screensaver' do
  desc 'screensaver is disabled'

  def hardware_uuid
    system_profiler_hardware_output = command('system_profiler SPHardwareDataType').stdout
    hardware_overview = Psych.load(system_profiler_hardware_output)['Hardware']['Hardware Overview']
    hardware_overview['Hardware UUID']
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :idleTime' /Users/vagrant/Library/Preferences/ByHost/com.apple.screensaver.#{hardware_uuid}.plist") do
    its('stdout') { should match(/0/) }
  end

  describe command('su vagrant -c "/usr/bin/defaults -currentHost read com.apple.screensaver idleTime"') do
    its('stdout') { should match(/0/) }
  end

  describe command('su vagrant -c "/usr/bin/defaults -currentHost read-type com.apple.screensaver idleTime"') do
    its('stdout') { should match(/integer/) }
  end

  describe command("file --brief --mime /Users/vagrant/Library/Preferences/ByHost/com.apple.screensaver.#{hardware_uuid}.plist") do
    its('stdout') { should match(/binary/) }
  end
end
