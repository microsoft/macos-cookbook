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

#########################################################################################################
#####
##### defaults -- access the Mac OS X user defaults system
#####
#########################################################################################################

system_setting 'com.apple.finder' do
  key 'AppleShowAllFiles'
  set true
end

system_setting 'com.apple.TimeMachine' do
  key 'DoNotOfferNewDisksForBackup'
  set false
end

system_setting 'com.apple.loginwindow' do
  key 'LoginwindowLaunchesRelaunchApps'
  set false
end

system_setting 'com.apple.loginwindow' do
  key 'TALLogoutSavesState'
  set 0
end

system_setting 'com.apple.screensaver' do
  key 'idleTime'
  set 0
end

system_setting 'com.apple.driver.AppleHIDMouse' do
  key 'Button2'
  set true
end

# bluetooth_settings = {
#     'ControllerPowerState' => 0,
#     'BluetoothAutoSeekKeyboard' => 0,
#     'BluetoothAutoSeekPointingDevice' => 0
# }
#
# system_setting 'com.apple.bluetooth' do
#   bluetooth_settings.each do |setting, value|
#     key setting
#     set value
#   end
# end
#
system_setting 'com.apple.bluetooth' do
  key 'ControllerPowerState'
  set 0
end

system_setting 'com.apple.bluetooth' do
  key 'BluetoothAutoSeekKeyboard'
  set 0
end

system_setting 'com.apple.bluetooth' do
  key 'BluetoothAutoSeekPointingDevice'
  set 0
end

system_setting 'com.apple.ImageCapture' do
  key 'disableHotPlug'
  set true
end

#########################################################################################################
#####
##### systemsetup -- configuration tool for certain machine settings in System Preferences.
#####
#########################################################################################################

system_setting 'setsleep' do
  set 0
end

system_setting 'setcomputersleep' do
  set 0
end

system_setting 'setdisplaysleep' do
  set 0
end

system_setting 'setharddisksleep' do
  set 0
end

system_setting 'setremoteappleevents' do
  set 'on'
end

system_setting 'setallowpowerbuttontosleepcomputer' do
  set 'off'
end


system_setting 'setwaitforstartupafterpowerfailure' do
  set 0
end


system_setting 'setrestartfreeze' do
  set 'on'
end

# system_setting 'setwakeonnetworkaccess' do
#   set 1
# end

#########################################################################################################
#####
##### pmset -- manipulate power management settings
#####
#########################################################################################################

system_setting 'powernap' do
  set 0
end

system_setting 'autorestart' do
  set 1
end

system_setting 'womp' do
  set 1
end

system_setting 'sleep' do
  set 0
end

system_setting 'hibernatefile' do
  set '/var/vm/sleepimage'
end

system_setting 'hibernatemode' do
  set 0
end

system_setting 'ttyskeepawake' do
  set 1
end


