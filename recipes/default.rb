#
# Cookbook:: macos-cookbook
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright:: 2017, Copyright © 2017 Microsoft. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

file 'create hidden file' do
  path "/Users/#{node['admin_user']}/Desktop/.file"
end

system_setting 'com.apple.bluetooth' do
  key 'ControllerPowerState'
  set_to false
end

system_setting 'com.apple.finder' do
  key 'AppleShowAllFiles'
  set_to true
end

system_setting 'com.apple.TimeMachine' do
  key 'DoNotOfferNewDisksForBackup'
  set_to false
end

system_setting 'com.apple.loginwindow' do
  key 'LoginwindowLaunchesRelaunchApps'
  set_to false
end

system_setting 'com.apple.loginwindow' do
  key 'TALLogoutSavesState'
  set_to false
end

system_setting 'com.apple.screensaver' do
  key 'idleTime'
  set_to false
end

system_setting 'com.apple.driver.AppleHIDMouse' do
  key 'Button2'
  set_to true
end

system_setting 'com.apple.Bluetooth' do
  key 'ControllerPowerState'
  set_to '0'
end

system_setting 'com.apple.Bluetooth' do
  key 'BluetoothAutoSeekKeyboard'
  set_to '0'
end

system_setting 'com.apple.Bluetooth' do
  key 'BluetoothAutoSeekPointingDevice'
  set_to '0'
end

system_setting 'sleep' do
  set_to '0'
end

system_setting 'computersleep' do
  set_to '0'
end

system_setting 'displaysleep' do
  set_to '0'
end



