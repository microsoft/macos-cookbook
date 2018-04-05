resource_name :certificate

property :certfile, String
property :cert_password, String
property :keychain, String
property :apps, Array

action_class do
  def keychain
    new_resource.property_is_set?(:keychain) ? new_resource.keychain : ''
  end
end

action :install do
  cert = SecurityCommand.new(new_resource.certfile, keychain)

  execute 'unlock keychain' do
    command [*cert.unlock_keychain(node['macos']['admin_user'])]
  end

  execute 'install-certificate' do
    command [*cert.install_certificate(new_resource.cert_password, new_resource.apps)]
  end
end
