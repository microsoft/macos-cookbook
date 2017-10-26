resource_name :plistbuddy

property :action, Symbol, name_property: true

property :entry
property :value
property :file
property :clear
property :data_type
property :sub_command

action_class do
  def plistbuddy_command(command_action, entry, value)
    entry = convert_to_data_type new_resource.entry
    "/usr/libexec/Plistbuddy -c ':#{command_action.capitalize.to_s} #{entry} #{value}"
  end

  private

  def convert_to_data_type(entry)
    data_type_cases = { Array.to_s => "array #{value}",
                      Integer.to_s => "int #{value}",
                      TrueClass.to_s => 'bool TRUE',
                      FalseClass.to_s => 'bool FALSE',
                      Hash.to_s => "dict #{value}",
                      String.to_s => "string #{value}",
                      Float.to_s => "float #{value}" }
    data_type_cases[entry]
  end
end
