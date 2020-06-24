provides :defaults

property :domain, String, name_property: true
property :option, String, default: 'write'
property :read_only, [true, false], default: false
property :settings, Hash
property :system, [true, false]
property :user, String

action :run do
  new_resource.option = 'read' if new_resource.read_only
  new_resource.settings.each do |setting, value|
    value = "-#{convert_to_string_from_data_type(value)}"
    execute "#{setting} to #{value}" do
      command "#{defaults_executable} #{new_resource.option} #{Shellwords.shellescape(new_resource.domain)} #{Shellwords.shellescape(setting)} #{value}"
      user new_resource.user
    end
  end
end
