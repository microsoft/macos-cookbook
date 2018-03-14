resource_name :keychain
default_action :create

property :kc_file, String
property :kc_passwd, String
property :default, [TrueClass, FalseClass], default: false
property :login, [TrueClass, FalseClass], default: false

action_class do
  def keychain
    property_is_set?(:kc_file) ? new_resource.kc_file : ''
  end
end

action :create do
  keyc = SecurityCommand.new('', keychain)

  execute 'create a keychain' do
    command [*keyc.create_keychain(new_resource.kc_passwd)]
  end

  if property_is_set?(:default)
    execute 'set as default keychain' do
      command [*keyc.default_keychain(new_resource.default)]
    end
  end

  if property_is_set?(:login)
    execute 'set as login keychain' do
      command [*keyc.login_keychain(new_resource.login)]
    end
  end
end

action :delete do
  keyc = SecurityCommand.new('', keychain)
  execute 'delete selected keychain' do
    command [*keyc.delete_keychain]
  end
end

action :lock do
  keyc = SecurityCommand.new('', keychain)
  execute 'lock selected keychain' do
    command [*keyc.lock_keychain]
  end
end

action :unlock do
  keyc = SecurityCommand.new('', keychain)
  execute 'unlock selected keychain' do
    command [*keyc.unlock_keychain(new_resource.kc_passwd)]
  end
end
