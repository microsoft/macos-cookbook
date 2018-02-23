resource_name :certificate
default_action :install

property :certfile, String
property :password, String
property :keychain, String

action_class do
  def security
    '/usr/bin/security'
  end

  def keychain
    if property_is_set?(:keychain)
      new_resource.keychain
    else
      ''
    end
  end
end

action :install do
  execute 'add certificate ' do
    if ::File.extname(certfile) == '.p12'
      command [security, 'import', new_resource.certfile, '-P', new_resource.password, keychain]
    elsif ::File.extname(certfile) == '.cer'
      command [security, 'add-certificates', new_resource.certfile]
    else
      Chef::Exception.fatal('invalid help')
    end
  end
end
