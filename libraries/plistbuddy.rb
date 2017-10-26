include Chef::Mixin::ShellOut

module MacOS
  module PlistBuddyHelpers
    # def self.exist?
    #   command = format_plistbuddy_command('print', entry, value)
    #   shell_out(command).error?
    # end
    def convert_to_string_from_data_type(plist_entry)
      data_type_cases = { Array.to_s => "array #{plist_entry}",
                          Integer.to_s => "int #{plist_entry}",
                          TrueClass.to_s => 'bool TRUE',
                          FalseClass.to_s => 'bool FALSE',
                          Hash.to_s => "dict #{plist_entry}",
                          String.to_s => "string #{plist_entry}",
                          Float.to_s => "float #{plist_entry}" }
      data_type_cases[plist_entry.class]
    end

    def format_plistbuddy_command(action_property, plist_entry, plist_value = nil)
      entry_wdt = convert_to_string_from_data_type plist_entry
      "/usr/libexec/Plistbuddy -c \':#{action_property.to_s.capitalize} #{plist_entry} #{plist_value}#{entry_wdt}\'"
    end
  end
end

Chef::Recipe.include(MacOS::PlistBuddyHelpers)
Chef::Resource.include(MacOS::PlistBuddyHelpers)
