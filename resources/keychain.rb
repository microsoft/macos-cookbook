unified_mode true

provides :keychain
default_action :create

property :path, String, name_property: true
property :password, String, sensitive: true
property :user, String

action_class do
  def security
    SecurityCommand.new('', new_resource.path)
  end
end

action :create do
  execute 'create a keychain' do
    command Array(security.create_keychain(new_resource.password))
    user new_resource.user
    sensitive true
    not_if { ::File.exist? new_resource.path + '-db' }
  end
end

action :delete do
  execute 'delete selected keychain' do
    command Array(security.delete_keychain)
    user new_resource.user
    sensitive true
    only_if { ::File.exist?(new_resource.path) }
  end
end

action :lock do
  execute 'lock selected keychain' do
    command Array(security.lock_keychain)
    user new_resource.user
    sensitive true
    only_if { ::File.exist?(new_resource.path) }
  end
end

action :unlock do
  execute 'unlock selected keychain' do
    command Array(security.unlock_keychain(new_resource.password))
    user new_resource.user
    sensitive true
    only_if { ::File.exist?(new_resource.path) }
  end
end
