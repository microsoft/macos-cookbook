unified_mode true

provides :certificate

property :certfile, String
property :cert_password, String, sensitive: true
property :keychain, String
property :kc_passwd, String, sensitive: true
property :apps, Array

action_class do
  def keychain
    new_resource.property_is_set?(:keychain) ? new_resource.keychain : ''
  end
end

action :install do
  cert = SecurityCommand.new(new_resource.certfile, keychain)

  execute 'unlock keychain' do
    password = new_resource.property_is_set?(:kc_passwd) ? new_resource.kc_passwd : node['macos']['admin_password']
    command Array(cert.unlock_keychain(password))
  end

  cert_shasum = shell_out("shasum #{new_resource.certfile}").stdout.upcase.gsub(/\s.+/, '')
  find_cert_output = shell_out("/usr/bin/security find-certificate -a -Z #{new_resource.keychain}").stdout

  execute 'install-certificate' do
    command Array(cert.install_certificate(new_resource.cert_password, new_resource.apps))
    not_if { find_cert_output.include? cert_shasum }
  end
end
