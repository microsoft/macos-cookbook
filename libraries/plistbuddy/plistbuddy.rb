include Shellwords

class PlistEntry
  attr_reader :name
  attr_reader :type
  attr_reader :container

  def initialize(name, type)
    @name = ':' + shellescape(name)
    @type = valid_types.include?(type) ? type : raise("Unrecognized type: #{type}")
    @container = @type == :array ? true : false
  end

  def valid_types
    [:string, :array, :dict, :bool, :real, :integer, :date, :data]
  end

  def add(value)
    [__method__.to_s, @name, @type, value] * ' '
  end

  def set(value)
    [__method__.to_s, @name, value] * ' '
  end
end

class PlistContainer
  def initialize(entry)
  end

  def create
  end

  def items(items)
  end

  def insert
  end

  def push(value)
  end
end

class PlistBuddyCommand
  def initialize(entry)
    @entry = entry
  end

  def set(value)
    command_wrapper @entry.set value
  end

  def add(value = nil)
    value = '' if @entry.container
    command_wrapper @entry.add value
  end

  private

  def command_wrapper(core_command)
    [plistbuddy_executable, '-c', "'#{core_command.strip}'"]
  end

  def plistbuddy_executable
    '/usr/libexec/PlistBuddy'
  end
end
