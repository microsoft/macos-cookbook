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
    case value
    when Array
      value = "-array #{value}"
    when Integer
      value = "-int #{value}"
    when TrueClass
      value = '-bool TRUE'
    when FalseClass
      value = '-bool FALSE'
    when Hash
      value = "-dict #{value}"
    else
      raise(Exception)
    end
    execute BASE_COMMAND do
      command "#{BASE_COMMAND} #{new_resource.option} #{new_resource.domain} #{setting} #{value}"
      user new_resource.user
    end
  end
end
