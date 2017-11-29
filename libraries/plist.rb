module MacOS
  module PlistHelpers
    def hardware_uuid
      system_profiler_hardware_output = shell_out('system_profiler', 'SPHardwareDataType').stdout
      hardware_overview = Psych.load(system_profiler_hardware_output)['Hardware']['Hardware Overview']
      hardware_overview['Hardware UUID']
    end

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

    def convert_to_data_type_from_string(type, value)
      case type
      when 'boolean'
        value.to_i == 1
      when 'integer'
        value.to_i
      when 'float'
        value.to_f
      when 'string'
        value
      end
    end

    def plistbuddy_command(subcommand_action, plist_entry, plist_path, plist_value = nil)
      plist_value = convert_to_string_from_data_type plist_value if subcommand_action.to_s == 'add'
      plist_entry = "\"#{plist_entry}\"" if plist_entry.include?(' ')
      full_subcommand = "#{subcommand_action.capitalize} :#{plist_entry} #{plist_value}"
      ['/usr/libexec/PlistBuddy', '-c', "\'#{full_subcommand}\'", plist_path].join(' ')
    end
  end
end

Chef::Recipe.include(MacOS::PlistHelpers)
Chef::Resource.include(MacOS::PlistHelpers)
