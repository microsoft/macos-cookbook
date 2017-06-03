# # encoding: utf-8

# Inspec test for recipe macos-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

power_management_plist = '/Library/Preferences/com.apple.PowerManagement'

describe user('admin') do
  it {should exist}
end

describe command("defaults read /Users/admin/Library/Preferences/com.apple.loginwindow") do
  its('stdout') {should match (/TALLogoutSavesState = 0;/)}
end

describe command("defaults read /Users/admin/Library/Preferences/com.apple.screensaver") do
  its('stdout') {should match (/idleTime = 0;/)}
end

describe command("defaults read #{power_management_plist}") do
  its('stdout') {should match (/"Automatic Restart On Power Loss" = 1;/)}
  its('stdout') {should match (/"Wake On LAN" = 1;/)}
  its('stdout') {should match (/PrioritizeNetworkReachabilityOverSleep = 1;/)}
  its('stdout') {should match (/"System Sleep Timer" = 0;/)}
  its('stdout') {should match (/TTYSPreventSleep = 1;/)}
  its('stdout') {should match (/DarkWakeBackgroundTasks = 0;/)}
  its('stdout') {should match (/"Standby Enabled" = 0;/)}
  its('stdout') {should match (/"Display Sleep Timer" = 0;/)}
  its('stdout') {should match (/"Disk Sleep Timer" = 0;/)}
  its('stdout') {should match (/"AutoPowerOff Enabled" = 0;/)}
  its('stdout') {should match (/"Hibernate Mode" = 0;/)}
end

