unified_mode true

provides :certificate
default_action :install

property :certfile, String
property :cert_password, String, sensitive: true
property :keychain, String, required: true
property :kc_passwd, String, required: true, sensitive: true
property :apps, Array
property :sensitive, [true, false], default: false

action :install do
  cert = SecurityCommand.new(new_resource.certfile, new_resource.keychain)

  execute 'unlock keychain' do
    command Array(cert.unlock_keychain(new_resource.kc_passwd))
    sensitive new_resource.sensitive
  end

  cert_shasum = shell_out("shasum #{new_resource.certfile}").stdout.upcase.gsub(/\s.+/, '')
  find_cert_output = shell_out("/usr/bin/security find-certificate -a -Z #{new_resource.keychain}").stdout

  execute 'install-certificate' do
    command Array(cert.install_certificate(new_resource.cert_password, new_resource.apps))
    sensitive new_resource.sensitive
    not_if { find_cert_output.include? cert_shasum }
  end
end
