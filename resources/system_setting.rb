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

property :bin, String, equal_to: [systemsetup, defaults]
property :preference, String, name_property: true
property :set, [Hash, String, true, false]
property :key, String
property :value, [String, Integer]
property :read_only, [true, false], default: false
property :defaults_option, String, default: 'write'
property :systemsetup_option, String, default: 'set'

load_current_value do |new_resource|
  if shell_out("#{systemsetup} -printCommands | grep #{new_resource.preference}").exitstatus == 0
    new_resource.bin systemsetup
    puts "\n\n++++++++++++++++++++++++++++++++++++"
    puts "====> binary: #{new_resource.bin}"
    puts "====> Preference: #{new_resource.preference}"
    puts "====> Set to: #{new_resource.set}"
    puts "====> Value: #{new_resource.value}"
    puts "++++++++++++++++++++++++++++++++++++\n"
  else
    new_resource.bin defaults
    puts "\n\n++++++++++++++++++++++++++++++++++++"
    puts "====> binary: #{new_resource.bin}"
    puts "====> Preference: #{new_resource.preference}"
    puts "====> Set to: #{new_resource.set}"
    puts "====> Key: #{new_resource.key}"
    puts "====> Value: #{new_resource.value}"
    puts "++++++++++++++++++++++++++++++++++++\n"
  end


  if new_resource.read_only
    new_resource.defaults_option 'read'
    new_resource.systemsetup_option 'get'
  else
    new_resource.defaults_option 'write'
    new_resource.systemsetup_option 'set'
  end
end

action :set do
  case new_resource.bin
    when systemsetup
      execute 'set or get preference using systemsetup' do
        command "#{systemsetup} -#{new_resource.systemsetup_option}#{new_resource.preference} #{new_resource.set} #{new_resource.value}"
      end

    when defaults
      execute 'set or get preference using defaults' do
        user node['admin_user']
        command "#{defaults} #{new_resource.defaults_option} #{new_resource.preference} #{new_resource.key} #{new_resource.set} #{new_resource.value}"
      end
    else
      puts 'Unknown binary'
  end

  execute 'restart Finder' do
    only_if {new_resource.preference == 'com.apple.finder'}
    command '/usr/bin/killall Finder'
  end
end

