#
# Author:: Eric Hanko (<v-erhank@microsoft.com>)
# Cookbook:: macos-cookbook
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

resource_name :system_setting
default_action :set

systemsetup = '/usr/sbin/systemsetup'
defaults = '/usr/bin/defaults'

property :set_to, String
property :domain, String
property :preference, String, name_property: true
property :value, [String, Integer]
property :bin, String, equal_to: [systemsetup, defaults]


load_current_value do |new_resource|
  if shell_out("#{systemsetup} -listCommands | grep #{new_resource.setting}").exitstatus == 0
    utility systemsetup
  else
    utility defaults
  end
end

action :set do
  case new_resource.bin
    when systemsetup
      execute 'set preference using systemsetup' do
        command "#{systemsetup} -set#{new_resource.preference} #{set_to} #{new_resource.value}"
      end

    when defaults
      execute 'set preference using defaults' do
        user node['admin_user']
        command "#{defaults} write #{new_resource.domain} #{new_resource.preference} #{set_to} #{new_resource.value}"
      end
    else
      pass
  end

  execute 'restart Finder' do
    only_if {new_resource.preference == 'com.apple.finder'}
    command '/usr/bin/killall Finder'
  end

end

