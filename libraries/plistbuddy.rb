include Chef::Mixin::ShellOut

module MacOS
  module PlistBuddyHelpers
    def convert_to_string_from_data_type(plist_entry)
      data_type_cases = { Array => "array #{plist_entry}",
                          Integer => "int #{plist_entry}",
                          TrueClass => 'true',
                          FalseClass => 'false',
                          Hash => "dict #{plist_entry}",
                          String => "string #{plist_entry}",
                          Float => "float #{plist_entry}" }
      data_type_cases[plist_entry.class]
    end

    def format_plistbuddy_command(action_property, plist_entry, plist_value = nil)
      value_with_data_type = convert_to_string_from_data_type plist_value
      "/usr/libexec/Plistbuddy -c \'#{action_property.to_s.capitalize} :#{plist_entry} #{value_with_data_type}\'" # Add a space here for the plist path
    end
  end
end

Chef::Recipe.include(MacOS::PlistBuddyHelpers)
Chef::Resource.include(MacOS::PlistBuddyHelpers)
