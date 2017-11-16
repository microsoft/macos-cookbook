module KcpasswordHelpers
  class Kcpassword << self
    def magic_bits
      [125, 137, 82, 35, 210, 188, 221, 234, 163, 185, 31]
    end

    def obfuscate(password)
      obfuscated = []
      padded(password).each do |char|
        obfuscated.push(@magic_bits[0] ^ char)
        @magic_bits.rotate
      end
      obfuscated.pack('C*')
    end

    private

    def padded(password)
      magic_len = @magic_bits.length
      padding = magic_len - (password.length % magic_len)
      padding_size = padding > 0 ? padding : 0
      translated(password) + ([0] * padding_size)
    end

    def translated(password)
      password.split('').map(&:ord)
    end
  end
end unless defined?(KcpasswordHelpers)

Chef::Recipe.include(KcpasswordHelpers)
Chef::Resource.include(KcpasswordHelpers)
