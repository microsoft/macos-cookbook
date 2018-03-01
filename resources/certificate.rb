resource_name :certificate
default_action :install

property :certfile, String
property :cert_password, String
property :keychain, String

action_class do
  def keychain
    if property_is_set?(:keychain)
      new_resource.keychain
    else
      ''
    end
  end
end

action :install do
  test = SecurityCommand.new(new_resource.certfile, keychain)

  execute 'unlock keychain' do
    command [*test.unlock_keychain('vagrant')]
  end

  execute 'install-certificate' do
    command [*test.install_certificate(new_resource.cert_password)]
  end
end
