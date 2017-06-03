#
# Author:: Eric Hanko (<v-erhank@microsoft.com>)
# Cookbook:: plist
# Resource:: plist
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

resource_name :plist

property :plist, String, name_property: true
property :preference, String, required: true
property :enabled, [true, false], required: true

default_action :set_preference

action :set_preference do
  execute 'set preference' do
    user node['admin_user']
    command "/usr/bin/defaults write #{plist} #{preference} #{enabled}"
  end

  execute 'restart Finder' do
    only_if { plist == 'com.apple.finder' }
    user node['admin_user']
    command '/usr/bin/killall Finder'
  end
end



