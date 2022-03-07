unified_mode true

provides :certificate

property :certfile, String
property :cert_password, String, sensitive: true
property :keychain, String
property :apps, Array
property :sensitive, [true, false], default: false

action_class do
  def keychain
    new_resource.property_is_set?(:keychain) ? new_resource.keychain : ''
  end
end

action :install do
  cert = SecurityCommand.new(new_resource.certfile, keychain)

  execute 'unlock keychain' do
    command Array(cert.unlock_keychain(node['macos']['admin_password']))
    sensitive new_resource.sensitive
  end

  execute 'install-certificate' do
    command Array(cert.install_certificate(new_resource.cert_password, new_resource.apps))
    sensitive new_resource.sensitive
  end
end
