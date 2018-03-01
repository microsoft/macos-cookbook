include Chef::Mixin::ShellOut

module MacOS
  class SecurityCommand
    attr_reader :cert
    attr_reader :keychain
    attr_reader :security

    def initialize(cert, keychain)
      @cert = cert
      @keychain = keychain
      @security = '/usr/bin/security'
    end

    def unlock_keychain(kc_passwd)
      [@security, 'unlock-keychain', '-p', kc_passwd]
    end

    def add_certificates
      if @keychain == ''
        [@security, 'add-certificates', @cert]
      else
        [@security, 'add-certificates', @cert, '-k', @keychain]
      end
    end

    def import(cert_passwd)
      [@security, 'import', @cert, '-P', cert_passwd, @keychain]
    end

    def install_certificate(cert_passwd)
      if ::File.extname(@cert) == '.p12'
        import(cert_passwd)
      elsif ::File.extname(@cert) == '.cer'
        add_certificates
      else
        Chef::Exception.fatal('invalid cert file')
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
