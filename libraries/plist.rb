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

    def plutil_executable
      '/usr/bin/plutil'
    end
  end
end

Chef::Recipe.include(MacOS::PlistHelpers)
Chef::Resource.include(MacOS::PlistHelpers)
