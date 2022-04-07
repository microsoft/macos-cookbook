unified_mode true

provides :certificate
default_action :install

property :path, String, name_property: true
property :password, String, sensitive: true
property :keychain_path, String
property :keychain_password, String, sensitive: true
property :apps, Array, default: []
property :user, String

action :install do
  cert = SecurityCommand.new(**{ cert: new_resource.path, keychain: new_resource.keychain_path})

  execute 'unlock keychain' do
    command Array(cert.unlock_keychain(new_resource.keychain_password))
    user new_resource.user
    sensitive true
  end

  cert_shasum = shell_out("shasum #{new_resource.path}").stdout.upcase.gsub(/\s.+/, '')
  find_cert_output = shell_out("/usr/bin/security find-certificate -a -Z #{new_resource.keychain_path}").stdout

  execute 'install-certificate' do
    command Array(cert.install_certificate(new_resource.password, new_resource.apps))
    user new_resource.user
    sensitive true
    not_if { find_cert_output.include? cert_shasum }
  end
end
