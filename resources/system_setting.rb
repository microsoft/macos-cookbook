require 'pry'

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
defaults    = '/usr/bin/defaults'
pmset       = '/usr/bin/pmset'

property :bin, String, equal_to: [systemsetup, defaults, pmset]
property :preference, String, name_property: true
property :set, [Integer, String, true, false]
property :key, [String, Hash]
property :value, [Integer]
property :read_only, [true, false], default: false
property :option, String, default: 'write'

load_current_value do |new_resource|
  if new_resource.preference =~ /com\.apple.*/
    new_resource.bin defaults
  elsif new_resource.preference =~ /(get.*|set.*)/
    new_resource.bin systemsetup
  else
    new_resource.bin pmset
  end
end

action :set do
  case new_resource.bin
  when systemsetup
    execute 'set or get preference using systemsetup' do
      command "#{systemsetup} -#{new_resource.preference} #{new_resource.key}
              \ #{new_resource.set}"
    end

  when defaults
    execute 'set or get preference using defaults' do
      user node['admin_user']
      command "#{defaults} #{new_resource.option} #{new_resource.preference} \
              #{new_resource.key} #{new_resource.set} #{new_resource.value}"
    end

  when pmset
    execute 'set or get preference using pmset' do
      command "#{pmset} -a #{new_resource.preference} #{new_resource.set}"
    end
  else
    puts nil
  end
end
