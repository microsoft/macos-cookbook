module OfficeMacDevEnv
  module PlistbuddyHelpers
    class PlistBuddy < Dir
    include Chef::Mixin::ShellOut

    def exist?(entry, value)
      shell_out!(plistbuddy_command('Print', entry, value))
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

    def execute_plistbuddy_command(command_action, entry, value)
      entry = convert_to_data_type new_resource.entry
      "/usr/libexec/Plistbuddy -c \':#{command_action.capitalize.to_s} #{entry} #{value}\'"
    end

  end
end

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend OfficeMacDevEnv::PlistbuddyHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend OfficeMacDevEnv::PlistbuddyHelpers
#       variables specific_key: my_helper_method
#     end
#
