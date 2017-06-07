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

resource_name :defaults

BASE_COMMAND = '/usr/bin/defaults'.freeze

property :domain, String, name_property: true
property :option, String, default: 'write'
property :read_only, [true, false], default: false
property :settings, Hash
property :system, [true, false]

action :run do
  if read_only
    new_resource.option = 'read'
  end

  settings.each do |setting, value|
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.option} #{new_resource.domain} #{setting} #{value}"
    end
  end
end