unified_mode true

provides :keychain
default_action :create

property :kc_file, String
property :kc_passwd, String, sensitive: true
property :user, String

action_class do
  def keychain
    new_resource.property_is_set?(:kc_file) ? new_resource.kc_file : nil
  end
end

action :create do
  keyc = SecurityCommand.new('', keychain)

  execute 'create a keychain' do
    command Array(keyc.create_keychain(new_resource.kc_passwd))
    user new_resource.user
    sensitive true
    not_if { ::File.exist? keychain + '-db' }
  end
end

action :delete do
  keyc = SecurityCommand.new('', keychain)
  execute 'delete selected keychain' do
    command Array(keyc.delete_keychain)
    user new_resource.user
    sensitive true
    only_if { ::File.exist?(keychain) }
  end
end

action :lock do
  keyc = SecurityCommand.new('', keychain)
  execute 'lock selected keychain' do
    command Array(keyc.lock_keychain)
    user new_resource.user
    sensitive true
    only_if { ::File.exist?(keychain) }
  end
end

action :unlock do
  keyc = SecurityCommand.new('', keychain)
  execute 'unlock selected keychain' do
    command Array(keyc.unlock_keychain(new_resource.kc_passwd))
    user new_resource.user
    sensitive true
    only_if { ::File.exist?(keychain) }
  end
end
