module MacOS
  module PlistBuddyHelpers
    def convert_to_string_from_data_type(value)
      data_type_cases = { Array => "array #{value}",
                          Integer => "integer #{value}",
                          TrueClass => "bool #{value}",
                          FalseClass => "bool #{value}",
                          Hash => "dict #{value}",
                          String => "string #{value}",
                          Float => "float #{value}" }
      data_type_cases[value.class]
    end

    def format_plistbuddy_command(action_property, plist_entry, plist_value = nil)
      plist_entry = "\"#{plist_entry}\"" if plist_entry.include?(' ')
      plist_value = args_formatter(action_property, plist_value)
      "/usr/libexec/PlistBuddy -c \'#{action_property.to_s.capitalize} :#{plist_entry} #{plist_value}\'"
    end

    private

    def args_formatter(action_property, plist_value)
      if action_property == :add
        convert_to_string_from_data_type plist_value
      else
        plist_value
      end
    end
  end
end

Chef::Recipe.include(MacOS::PlistBuddyHelpers)
Chef::Resource.include(MacOS::PlistBuddyHelpers)
