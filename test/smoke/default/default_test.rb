# # encoding: utf-8

# Inspec test for recipe macos-cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('admin') do
  it {should exist}
end

describe command("defaults read com.apple.loginwindow") do
  its(:stdout) do
    is_expected.to match(/TALLogoutSavesState = 0;/)
  end
end

describe command("defaults read com.apple.screensaver") do
  its(:stdout) do
    is_expected.to match(/idleTime = 0;/)
  end
end