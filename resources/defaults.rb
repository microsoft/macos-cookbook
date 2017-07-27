resource_name :defaults

BASE_COMMAND = '/usr/bin/defaults'.freeze

property :domain, String, name_property: true
property :option, String, default: 'write'
property :read_only, [true, false], default: false
property :settings, Hash
property :system, [true, false]
property :user, String

action :run do
  new_resource.option = 'read' if read_only
  settings.each do |setting, value|
    cases = { Array.to_s => "-array #{value}",
              Integer.to_s => "-int #{value}",
              TrueClass.to_s => '-bool TRUE',
              FalseClass.to_s => '-bool FALSE',
              Hash.to_s => "-dict #{value}",
              String.to_s => "-string #{value}" }
    value = cases[value.class.to_s]
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.option} #{new_resource.domain} #{setting} #{value}"
      user new_resource.user
    end
  end
end
