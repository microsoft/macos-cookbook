module PlistBuddy
  module Helper
    include Chef::Mixin::ShellOut

    def self.exist?
      command = format_plistbuddy_command('print', entry, value)
      shell_out(command).error?
    end

    private

    def convert_to_string_from_data_type(entry)
      data_type_cases = { Array.to_s => "array #{value}",
                          Integer.to_s => "int #{value}",
                          TrueClass.to_s => 'bool TRUE',
                          FalseClass.to_s => 'bool FALSE',
                          Hash.to_s => "dict #{value}",
                          String.to_s => "string #{value}",
                          Float.to_s => "float #{value}" }
      data_type_cases[entry]
    end

    def format_plistbuddy_command(action_property, entry, value)
      entry = convert_to_data_type enty
      "/usr/libexec/Plistbuddy -c \':#{action_property.to_s.capitalize} #{entry} #{value}\'"
    end
  end
end

Chef::Recipe.include(PlistBuddy::Helper)
Chef::Resource.include(PlistBuddy::Helper)
