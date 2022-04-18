include Chef::Mixin::ShellOut

module MacOS
  class SecurityCommand
    attr_reader :cert, :keychain, :security_cmd

    def initialize(cert: nil, keychain: nil)
      @cert = cert
      @keychain = keychain
      @security_cmd = '/usr/bin/security'
    end

    def create_keychain(kc_pass)
      Chef::Exception.fatal('New keychains require a password.') if kc_pass.empty?

      [@security_cmd, 'create-keychain', '-p', kc_pass, @keychain]
    end

    def delete_keychain
      [@security_cmd, 'delete-keychain', @keychain]
    end

    def lock_keychain
      if @keychain.nil?
        [@security_cmd, 'lock-keychain']
      else
        [@security_cmd, 'lock-keychain', @keychain]
      end
    end

    def unlock_keychain(password)
      if @keychain.nil?
        [@security_cmd, 'unlock-keychain', '-p', password]
      else
        [@security_cmd, 'unlock-keychain', '-p', password, @keychain]
      end
    end

    def add_certificates
      if @keychain.nil?
        [@security_cmd, 'add-certificates',
         @cert]
      else
        [@security_cmd, 'add-certificates', '-k', @keychain, @cert]
      end
    end

    def import(cert_passwd, apps)
      app_array = []

      apps.each do |app|
        app_array.push('-T')
        app_array.push(app)
      end

      if @keychain.nil?
        [@security_cmd, 'import', @cert, '-P', cert_passwd, *app_array]
      else
        [@security_cmd, 'import', @cert, '-P', cert_passwd, '-k', @keychain, *app_array]
      end
    end

    def install_certificate(cert_passwd, apps)
      valid_pkcs12 = ['.p12', '.pfx']
      valid_certs = ['.der', '.crt', '.cer']

      apps.each do |app|
        Chef::Exception.fatal("Invalid application: #{@app}.") unless app.is_a? String
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

Chef::DSL::Recipe.include(MacOS)
Chef::Resource.include(MacOS)
