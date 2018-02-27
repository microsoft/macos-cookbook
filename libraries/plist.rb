require 'plist'
require 'tempfile'

module MacOS
  module PlistHelpers
    def cli_value_handler(_subcommand, _value)
      commands.is_a?(Array) ? commands : [commands]
    end

    def plist_array_handler(value)
      commands = []
      value.each do |item|
        full_cmd = [value.index(item).to_s, type_to_commandline_string(item), item]
        commands.push(full_cmd.join(' '))
      end
      commands
    end

    def find_items_in_array(entry, path)
      defaults_read = shell_out(defaults_executable, 'read', path, entry)
      items = defaults_read.stdout.tr("\(\)\n\s", '').split(',')
      items.each do |vals|
        setting_from_plist(vals)
      end
    end

    def entry_type_to_string(value)
      type_map = { Integer => 'integer',
                   TrueClass => 'bool',
                   FalseClass => 'bool',
                   Hash => 'dict',
                   String => 'string',
                   Float => 'float' }
      begin
        type_map[value.class]
      rescue
        raise "Tried to set \'#{value}\' of an unsupported data type: #{value.class}"
      end
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

    def setting_from_plist(entry, path)
      defaults_read_type = shell_out(defaults_executable, 'read-type', path, entry)
      defaults_read = shell_out(defaults_executable, 'read', path, entry)
      { key_type: defaults_read_type.stdout.split.last, key_value: defaults_read.stdout.strip }
    end

    def defaults_array_items(entry, path)
      defaults_read = shell_out(defaults_executable, 'read', path, entry)
      defaults_read.stdout.tr("\(\)\n\s", '').split(',')
    end

    def convert_to_hash(path)
      temp_file = Tempfile.new.path
      FileUtils.copy(path, temp_file)
      shell_out!(plutil_executable, '-convert', 'xml1', temp_file)
      Plist.parse_xml(temp)
    end

    def defaults_executable
      '/usr/bin/defaults'
    end

    def plistbuddy_executable
      '/usr/libexec/PlistBuddy'
    end

    def plutil_executable
      '/usr/bin/plutil'
    end
  end
end

Chef::Recipe.include(MacOS::PlistHelpers)
Chef::Resource.include(MacOS::PlistHelpers)
