require 'spec_helper'

describe 'setting the first day of the week to monday' do
  step_into :plist

  platform 'mac_os_x', 10.14

  recipe do
    plist 'make Monday the first DOW' do
        path '/Users/somebody/Library/Preferences/.GlobalPreferences.plist'
        entry 'AppleFirstWeekday'
        value "{ 'gregorian' => 2;}"
        owner 'somebody'
        group 'staff'
    end
  end

  it { is_expected.to run_execute("/usr/libexec/PlistBuddy -c 'Set :\"AppleFirstWeekday\":gregorian 4' \"/Users/somebody/Library/Preferences/.GlobalPreferences.plist\"") }
end
