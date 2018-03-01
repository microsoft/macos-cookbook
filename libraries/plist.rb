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
        value.container?(value) ? container_handler(value) : type_map[value.class]
      rescue
        raise "Tried to set \'#{value}\' of an unsupported data type: #{value.class}"
      end
    end

    def container?(value)
      value.class == Array || value.class == Hash
    end

    private

    def container_handler(container_items)
      index = container_items.index(item).to_s
      item_type = entry_type_to_string(item)
      container_items.collect { |item| [index, item_type, item].join(' ') }
    end
  end
end

Chef::Recipe.include(MacOS::PlistHelpers)
Chef::Resource.include(MacOS::PlistHelpers)
