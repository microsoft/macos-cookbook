resource_name :systemsetup
default_action :run

BASE_COMMAND = '/usr/sbin/systemsetup'.freeze

property :option, String, default: '-set'
property :read_only, [true, false], default: false
property :settings, Hash
property :system_setting, [true, false], default: false

action :run do
  if read_only
    new_resource.option = '-get'
  end
  settings.each do |flag, setting|
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.option}#{flag} #{setting}"
    end
  end
end
