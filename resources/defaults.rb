unified_mode true

provides :defaults

property :domain, String, name_property: true
property :option, String, default: 'write'
property :read_only, [true, false], default: false
property :settings, Hash
property :system, [true, false]
property :user, String

action_class do
  def convert_to_string_from_data_type(value)
    case value
    when Array
      "-array #{value.map { |x| convert_to_string_from_data_type(x) }.join(' ')}"
    when Integer
      "-integer #{value}"
    when FalseClass
      "-bool #{value}"
    when TrueClass
      "-bool #{value}"
    when Hash
      "-dict #{value.map do |k, v|
                 Shellwords.shellescape(k) + ' ' + convert_to_string_from_data_type(v)
               end.join(' ')}"
    when String
      "-string #{Shellwords.shellescape(value)}"
    when Float
      "-float #{value}"
    else
      raise "Unknown or unsupported data type: #{value} of #{value.class}"
    end
  end
end

action :run do
  new_resource.option = 'read' if new_resource.read_only
  new_resource.settings.each do |setting, value|
    value = "#{convert_to_string_from_data_type(value)}"
    execute "#{setting} to #{value}" do
      command "/usr/bin/defaults #{new_resource.option} #{Shellwords.shellescape(new_resource.domain)} #{Shellwords.shellescape(setting)} #{value}"
      user new_resource.user
      environment ({ 'HOME' => Etc.getpwnam(new_resource.user).dir })
    end
  end
end
