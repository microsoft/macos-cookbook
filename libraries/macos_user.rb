module MacOS
  module MacOSUserHelpers
    def kcpassword_hash(password)
      bits = if password.nil?
               nil_magic_bits
             else
               magic_bits
             end
      obfuscated = []
      padded(password.to_s).each do |char|
        obfuscated.push(bits[0] ^ char)
        bits.rotate!
      end
      obfuscated.pack('C*')
    end

    private

    def magic_bits
      [125, 137, 82, 35, 210, 188, 221, 234, 163, 185, 31]
    end

    def nil_magic_bits
      [125, 238, 148, 74, 161, 237, 34, 160, 79, 144, 210, 199]
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

Chef::DSL::Recipe.include(MacOS::MacOSUserHelpers)
Chef::Resource.include(MacOS::MacOSUserHelpers)
