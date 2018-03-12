include Chef::Mixin::ShellOut

module MacOS
  class SecurityCommand
    attr_reader :cert
    attr_reader :keychain
    attr_reader :security_cmd

    def initialize(cert, keychain)
      @cert = cert
      @keychain = keychain
      @security_cmd = '/usr/bin/security'
    end

    def unlock_keychain(kc_passwd)
      @keychain == '' ? [@security_cmd, 'unlock-keychain', '-p', kc_passwd] : [@security_cmd, 'unlock-keychain', '-p', kc_passwd, @keychain]
    end

    def add_certificates
      @keychain == '' ? [@security_cmd, 'add-certificates', @cert] : [@security_cmd, 'add-certificates', @cert, '-k', @keychain]
    end

    def import(cert_passwd, apps)
      app_array = []

      apps.each do |app|
        app_array.push('-T')
        app_array.push(app)
      end
      @keychain == '' ? [@security_cmd, 'import', @cert, '-P', cert_passwd, *app_array] : [@security_cmd, 'import', @cert, '-P', cert_passwd, '-k', @keychain, *app_array]
    end

    def install_certificate(cert_passwd, apps)
      valid_pkcs12 = ['.p12', '.pfx']
      valid_certs = ['.der', '.crt', '.cer']

      apps.each do |app|
        unless app.is_a? String
          Chef::Exception.fatal("Invalid application: #{@app}.")
        end
      end

      if valid_pkcs12.any? { |extension| ::File.extname(@cert).match? extension }
        import(cert_passwd, apps)
      elsif valid_certs.any? { |extension| ::File.extname(@cert).match? extension }
        add_certificates
      else
        Chef::Exception.fatal("Invalid certificate: #{@cert}. We looked in the #{@keychain} keychain. Double-check the integrity of both the certificate and the keychain.")
      end
    end
  end
end

Chef::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
