resource_name :keychain
default_action :create

property :kc_file, String
property :kc_passwd, String

action_class do
  def keychain
    new_resource.property_is_set?(:kc_file) ? new_resource.kc_file : nil
  end
end

action :create do
  keyc = SecurityCommand.new('', keychain)

  execute 'create a keychain' do
    command [*keyc.create_keychain(new_resource.kc_passwd)]
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
  keyc = SecurityCommand.new('', keychain) do
    command [*keyc.unlock_keychain(new_resource.kc_passwd)]
  end
end
