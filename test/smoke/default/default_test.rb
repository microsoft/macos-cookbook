# # encoding: utf-8

# Inspec test for recipe macos-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

sleep_settings = %w(getsleep getcomputersleep getdisplaysleep getharddisksleep)
power_settings = %w(getrestartfreeze getremoteappleevents)

describe user('admin') do
  it {should exist}
end

describe command("defaults read /Users/admin/Library/Preferences/com.apple.loginwindow") do
  its('stdout') {should match (/TALLogoutSavesState = 0;/)}
end

describe command("defaults read /Users/admin/Library/Preferences/com.apple.screensaver") do
  its('stdout') {should match (/idleTime = 0;/)}
end

sleep_settings.each do |sleep_setting|
  describe command("systemsetup -#{sleep_setting}") do
    its('stdout') {should match 'Never'}
  end
end

power_settings.each do |power_setting|
  describe command("systemsetup -#{power_setting}") do
    its('stdout') {should match 'On'}
  end
end

describe command("systemsetup -getwaitforstartupafterpowerfailure") do
  its('stdout') {should match '0 seconds'}
end


