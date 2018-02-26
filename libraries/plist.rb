module MacOS
  module PlistHelpers
    def convert_to_data_type_from_string(type, value) # used in the plist resource
      case type
      when 'boolean'
        value.to_i == 1
      when 'integer'
        value.to_i
      when 'float'
        value.to_f
      when 'string'
        value
      when nil
        ''
      else
        raise "Unknown or unsupported data type: #{type.class}"
      end
    end

    def type_to_commandline_string(value) # used in plistbuddy_command
      case value
      when Array
        plist_array_handler(value)
      when Integer
        'integer'
      when FalseClass
        'bool'
      when TrueClass
        'bool'
      when Hash
        'dict'
      when String
        'string'
      when Float
        'float'
      else
        raise "Unknown or unsupported data type: #{value} of #{value.class}"
      end
    end

    def plist_array_handler(value)
      commands = []
      value.each do |item|
        full_cmd = [value.index(item).to_s, type_to_commandline_string(item), item]
        commands.push(full_cmd.join(' '))
      end
      commands
    end

    def convert_to_string_from_data_type(value) # used in the defaults resource
      data_type_cases = { Array => "array #{value}",
                          Integer => "integer #{value}",
                          TrueClass => "bool #{value}",
                          FalseClass => "bool #{value}",
                          Hash => "dict #{value}",
                          String => "string #{value}",
                          Float => "float #{value}" }
      data_type_cases[value.class]
    end

    def print_entry_value(entry, path)
      cmd = shell_out(plistbuddy_command(:print, entry, path))
      cmd.exitstatus == 0
    end

    def hardware_uuid
      system_profiler_hardware_output = shell_out('system_profiler', 'SPHardwareDataType').stdout
      hardware_overview = Psych.load(system_profiler_hardware_output)['Hardware']['Hardware Overview']
      hardware_overview['Hardware UUID']
    end

    def cli_value_handler(subcommand, value)
      commands = case subcommand.to_s
                 when 'add'
                   type_to_commandline_string(value)
                 when 'print'
                   ''
                 else
                   value
                 end
      commands.is_a?(Array) ? commands : [commands]
    end

    def plistbuddy_command(subcommand, entry, path, resource_value = nil)
      commands = []
      args = cli_value_handler(subcommand, resource_value)
      args.each do |arg|
        sep = resource_value.is_a?(Array) ? ':' : ' '
        entry_with_arg = ["\"#{entry}\"", arg].join(sep).strip
        full_noninteractive_command = "#{subcommand.capitalize} :#{entry_with_arg}"
        command = [plistbuddy_executable, '-c', "\'#{full_noninteractive_command}\'", "\"#{path}\""].join(' ')
        commands.push(command)
      end
      commands
    end

    def setting_from_plist(entry, path)
      defaults_read_type_output = shell_out(defaults_executable, 'read-type', path, entry).stdout
      defaults_read_output = shell_out(defaults_executable, 'read', path, entry).stdout
      { key_type: defaults_read_type_output.split.last, key_value: defaults_read_output.strip }
    end

    private

    def defaults_executable
      '/usr/bin/defaults'
    end

    def plistbuddy_executable
      '/usr/libexec/PlistBuddy'
    end
  end
end

Chef::Recipe.include(MacOS::PlistHelpers)
Chef::Resource.include(MacOS::PlistHelpers)
