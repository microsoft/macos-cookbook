module MacOS
  module MacOSUserHelpers
    def kcpassword_hash(password)
      bits = magic_bits
      obfuscated = []
      padded(password).each do |char|
        obfuscated.push(bits[0] ^ char)
        bits.rotate!
      end
      obfuscated.pack('C*')
    end

    def user_is_hidden?
      read_command = shell_out dscl, '.', 'read', user_home, key
      current_value = read_command.stdout.empty? ? 0 : read_command.stdout.split(':').last.strip
    end

    private

    def magic_bits
      [125, 137, 82, 35, 210, 188, 221, 234, 163, 185, 31]
    end

    def magic_len
      magic_bits.length
    end

    def padded(password)
      padding = magic_len - (password.length % magic_len)
      padding_size = padding > 0 ? padding : 0
      translated(password) + ([0] * padding_size)
    end

    def translated(password)
      password.split('').map(&:ord)
    end
  end
end

Chef::Recipe.include(MacOS::MacOSUserHelpers)
Chef::Resource.include(MacOS::MacOSUserHelpers)
