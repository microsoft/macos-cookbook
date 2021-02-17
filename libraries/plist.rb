module MacOS
  module PlistHelpers
    def convert_to_data_type_from_string(type, value)
      case type
      when 'boolean'
        # Since we've determined this is a boolean data type, we can assume that:
        # If the value as an int is 1, return true
        # If the value as an int is 0 (not 1), return false
        value.to_i == 1
      when 'integer'
        value.to_i
      when 'float'
        value.to_f
      when 'string'
        value
      when 'dictionary'
        value
      when nil
        ''
      else
        raise "Unknown or unsupported data type: #{type.class}"
      end
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

    def type_to_commandline_string(value)
      case value
      when Array
        'array'
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

    def entry_in_plist?(entry, path)
      print_entry = plistbuddy_command :print, entry, path
      cmd = shell_out print_entry
      cmd.exitstatus == 0
    end

    def hardware_uuid
      system_profiler_hardware_output = shell_out('system_profiler', 'SPHardwareDataType').stdout
      hardware_overview = Psych.load(system_profiler_hardware_output)['Hardware']['Hardware Overview']
      hardware_overview['Hardware UUID']
    end

    def plistbuddy_command(subcommand, entry, path, value = nil)
      sep = ' '
      arg = case subcommand.to_s
            when 'add'
              type_to_commandline_string(value)
            when 'set'
              if value.class == Hash
                sep = ':'
                value.map { |k, v| "#{k} #{v}" }
              else
                value
              end
            else
              ''
            end
      entry_with_arg = ["\"#{entry}\"", arg].join(sep).strip
      subcommand = "#{subcommand.capitalize} :#{entry_with_arg}"
      [plistbuddy_executable, '-c', "\'#{subcommand}\'", "\"#{path}\""].join(' ')
    end

    def setting_from_plist(entry, path)
      defaults_read_type_output = shell_out(defaults_executable, 'read-type', path, entry).stdout
      data_type = defaults_read_type_output.split.last

      if value.class == Hash
        plutil_output = shell_out(plutil_executable, '-extract', entry, 'xml1', '-o', '-', path).stdout.chomp
        { key_type: data_type, key_value: Plist.parse_xml(plutil_output) }
      else
        defaults_read_output = shell_out(defaults_executable, 'read', path, entry).stdout
        { key_type: data_type, key_value: defaults_read_output.strip }
      end
    end

    def plutil_format_map
      { 'us-ascii' => 'xml1',
        'text/xml' => 'xml1',
        'utf-8' => 'xml1',
        'binary' => 'binary1' }
    end

    private

    def plutil_executable
      '/usr/bin/plutil'
    end

    def defaults_executable
      '/usr/bin/defaults'
    end

    def plistbuddy_executable
      '/usr/libexec/PlistBuddy'
    end
  end
end
Chef::Resource.include MacOS::PlistHelpers
Chef::DSL::Recipe.include MacOS::PlistHelpers
