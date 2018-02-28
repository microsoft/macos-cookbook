require 'plist'
require 'tempfile'

module MacOS
  module PlistHelpers
    def entry_type_to_string(value)
      type_map = { Integer => 'integer',
                   TrueClass => 'bool',
                   FalseClass => 'bool',
                   Hash => 'dict',
                   String => 'string',
                   Float => 'float' }
      begin
        value.is_container?(value) ? container_handler(value) : type_map[value.class]
      rescue
        raise "Tried to set \'#{value}\' of an unsupported data type: #{value.class}"
      end
    end

    def is_container?(value)
      value.class == Array or value.class == Hash
    end

    private

    def cli_value_handler(_subcommand, _value)
      commands.is_a?(Array) ? commands : [commands]
    end

    def container_handler(value)
      commands = []
      value.each do |item|
        full_cmd = [value.index(item).to_s, entry_type_to_string(item), item]
        commands.push(full_cmd.join(' '))
      end
      commands
    end
  end
end

Chef::Recipe.include(MacOS::PlistHelpers)
Chef::Resource.include(MacOS::PlistHelpers)
