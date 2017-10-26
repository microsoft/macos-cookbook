resource_name :plistbuddy

property :action, Symbol, name_property: true

property :name, String
property :entry, String
property :value, [Hash, String, Array, TrueClass, FalseClass, Int, Float]

action_class do
  # def plistbuddy_command(command_action, entry, value)
  #   entry = convert_to_data_type new_resource.entry
  #   "/usr/libexec/Plistbuddy -c ':#{command_action.capitalize} #{entry} #{value}"
  # end

  # private

  # def convert_to_data_type(entry)
  #   data_type_cases = { Array.to_s => "array #{new_resource.value}",
  #                       Integer.to_s => "int #{new_resource.value}",
  #                       TrueClass.to_s => 'bool TRUE',
  #                       FalseClass.to_s => 'bool FALSE',
  #                       Hash.to_s => "dict #{new_resource.value}",
  #                       String.to_s => "string #{new_resource.value}",
  #                       Float.to_s => "float #{new_resource.value}" }
  #   data_type_cases[entry]
  # end
end
