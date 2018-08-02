# four-byte string-type field
# four-byte big-endian length field
# the value itself

module MacOS
  class Keybag
    attr_reader :content

    def initialize
      @data = IO.read path, mode: 'rb'
      @content = {}
    end

    def admin_user
      Chef.node['macos']['admin_user']
    rescue
      ENV['USER']
    end

    def path
      File.join '/', 'Users', admin_user, 'Library', 'Keychains', System::Hardware.uuid, 'user.kb'
    end

    def analyze(data, offset)
      identifier_offset = offset
      length_offset = identifier_offset + 4
      data_offset = length_offset + 4
      identifier = data[identifier_offset...length_offset]
      length = data[length_offset...data_offset].unpack('l>').first
      block_end = data_offset + length
      # content[identifier] = data[data_offset...block_end].unpack('l>').first
      # puts "Identifier: #{identifier}"
      # puts "Length: #{length}"
      # puts "Block end: #{block_end}"
      { key: identifier, length: length, start: data_offset, end: block_end }
    end

    # def calculate
    #   offset = 8

    #   while offset < total_length

    #   end
    # end

    def total_length
      data[4...8].unpack('l>').first
    end
  end
end
