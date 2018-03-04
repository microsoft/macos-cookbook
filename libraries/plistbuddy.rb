include Shellwords

module MacOS
  class PlistBuddy
    attr_reader :path
    attr_reader :entry
    attr_reader :value
    attr_accessor :new_container

    def initialize(entry, path)
      @entry = ':' + shellescape(entry)
      @path = shellescape(path)
      @new_container = false
    end

    def add(value)
      construct_command __method__.to_s.capitalize, data_type_as_string(value), type_handler(value)
    end

    def set(value)
      construct_command __method__.to_s.capitalize, type_handler(value)
    end

    def delete
      construct_command __method__.to_s.capitalize
    end

    def print
      construct_command __method__.to_s.capitalize
    end

    private

    def data_type_as_string(value)
      type_map = { Integer => 'integer',
                   TrueClass => 'bool',
                   FalseClass => 'bool',
                   Hash => 'dict',
                   String => 'string',
                   Float => 'float',
                   Array => 'array',
                   NilClass => '' }
      begin
        type_map[value.class]
      rescue
        raise "Tried to set \'#{value}\' of an unsupported data type: #{value.class}"
      end
    end

    def container_contents_handler(contents)
      contents.collect { |item| [contents.index(item).to_s, data_type_as_string, item].join(' ') }
    end

    def type_handler(value)
      @new_container ? '' : shellescape(value)
    end

    def construct_command(action, *components)
      core_command = [action, @entry, components].join(' ').strip
      plistbuddy_wrapper core_command
    end

    def plistbuddy_wrapper(core_command)
      [plistbuddy_executable, '-c', "'#{core_command}'", @path]
    end

    def add_container # dict or array logic goes here
    end

    def plistbuddy_executable
      '/usr/libexec/PlistBuddy'
    end
  end

  class PlistContainer < PlistBuddy
    def initialize(name, path)
      super(name, path)
      @new_container = true
    end

    def create
      add []
    end

    def items(items)
      puts items
    end

    def insert(_index, _entry)
      add
    end

    def push(value)
      puts value
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
