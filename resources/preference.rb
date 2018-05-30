resource_name :preference

property :domain, String,
         name_property: true

property :scope, Symbol,
         equal_to: [:current_host, :user, :system],
         default: :user

property :name, String

property :value, [Float, Integer, String, true, false],
         desired_state: true

load_current_value do |desired|
  value = setting_from_plist desired.value, desired.domain
  value TypeConversion::TypeConverter.to_native_from_string value[:key_type], value[:key_value]

  shell_out_options = {}
  shell_out_options[:user] = desired.user if desired.scope == :user

  # value_command = shell_out('', shell_out_options)
  # is_set value_command.exitstatus == 0
  # TypeConversion::TypeConverter.to_string_from_native(value)
end
