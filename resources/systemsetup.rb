# Author:: Eric Hanko (<v-erhank@microsoft.com>)
# Cookbook:: macos
# Resource:: system_setting
#
# Copyright:: 2017, Microsoft, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

resource_name :systemsetup
default_action :run

BASE_COMMAND = '/usr/sbin/systemsetup'.freeze

property :read_only, [true, false], default: false
property :settings, Hash
property :system_setting, [true, false], default: false

action :run do
  new_resource.settings.each do |flag, setting|
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} -set#{flag} #{setting}"
    end
  end
end

# Available key/value pairs to use with the systemsetup resource:

# date <mm:dd:yy>
# time <hh:mm:ss>
# timezone <timezone>
# usingnetworktime <on off>
# networktimeserver <timeserver>
# sleep <minutes>
# computersleep <minutes>
# displaysleep <minutes>
# harddisksleep <minutes>
# wakeonmodem <on off>
# wakeonnetworkaccess <on off>
# restartpowerfailure <on off>
# restartfreeze <on off>
# allowpowerbuttontosleepcomputer <on off>
# remotelogin <on off>
# remoteappleevents <on off>
# computername <computername>
# localsubnetname <name>
# startupdisk <disk>
# waitforstartupafterpowerfailure <seconds>
# disablekeyboardwhenenclosurelockisengaged <yes no>

# Example usage:

# systemsetup 'keep machine awake indefinitely' do
#   settings {remotelogin: 'On',
#             waitforstartupafterpowerfailure: 0,
#             displaysleep: 0}
# end
