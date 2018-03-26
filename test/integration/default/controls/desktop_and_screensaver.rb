title 'desktop and screen saver'

user_home = os_env('HOME').content
test_user = 'vagrant'

control 'screensaver-disabled' do
  title 'idletime is set to zero'
  desc 'Verify that when the computer is not in use, moving images or patterns do not appear'

  def hardware_uuid
    system_profiler_command = command('/usr/sbin/system_profiler SPHardwareDataType')
    hardware_data = ::Psych.load(system_profiler_command.stdout)
    hardware_data['Hardware']['Hardware Overview']['Hardware UUID']
  end

  describe command('/usr/sbin/system_profiler SPHardwareDataType') do
    its('stdout') { should_not be nil }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :idleTime' #{user_home}/Library/Preferences/ByHost/com.apple.screensaver.#{hardware_uuid}.plist") do
    its('stdout') { should match(/0/) }
  end

  describe command("su #{test_user} -c 'defaults -currentHost read com.apple.screensaver idleTime'") do
    its('stdout') { should match(/0/) }
  end

  describe command("su #{test_user} -c 'defaults -currentHost read-type com.apple.screensaver idleTime'") do
    its('stdout') { should match(/integer/) }
  end

  describe command("file --brief --mime #{user_home}/Library/Preferences/ByHost/com.apple.screensaver.#{hardware_uuid}.plist") do
    its('stdout') { should match(/binary/) }
  end
end
