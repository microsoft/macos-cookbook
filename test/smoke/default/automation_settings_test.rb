# # encoding: utf-8

# Inspec test for recipe macos-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

never_settings = %w(getsleep getcomputersleep getdisplaysleep getharddisksleep)
on_settings    = %w(getrestartfreeze getremoteappleevents)
user_library   = '/Users/admin/Library/Preferences'

describe user('admin') do
  it { should exist }
end

describe command("defaults read #{user_library}/com.apple.loginwindow") do
  its('stdout') { should match(/TALLogoutSavesState = 0;/) }
end

describe command("defaults read #{user_library}/com.apple.screensaver") do
  its('stdout') { should match(/idleTime = 0;/) }
end

never_settings.each do |never_setting|
  describe command("systemsetup -#{never_setting}") do
    its('stdout') { should match 'Never' }
  end
end

on_settings.each do |on_setting|
  describe command("systemsetup -#{on_setting}") do
    its('stdout') { should match 'On' }
  end
end

describe command('systemsetup -getwaitforstartupafterpowerfailure') do
  its('stdout') { should match '0 seconds' }
end
