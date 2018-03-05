class PlistBuddyCommand
  def initialize(entry)
    @entry = entry
  end

  def clear(type = nil)
    # Clear [<Type>]
  end

  def print(entry = nil)
    # Print [<Entry>]
  end

  def set
    # Set <Entry> <Value>
    __method__.to_s.capitalize + @entry.name + @entry.value
  end

  def add
    # Add <Entry> <Type> [<Value>]
    __method__.to_s.capitalize + @entry.name + @entry.type
  end

  def copy
    # Copy <EntrySrc> <EntryDst>
  end

  def delete
    # Delete <Entry>
  end

  def merge
    # Merge <file.plist> [<Entry>]
  end

  def import
    # Import <Entry> <file>
  end
end

Plist.class_eval { include PlistEntry }
