user = 'test_user'
user_home = File.join('/', 'Users', user)

if Gem::Version.new(node['platform_version']) >= Gem::Version.new('10.13')
  admin_credentials = ['-adminUser', node['macos']['admin_user'], '-adminPassword', node['macos']['admin_password']]
else ''
end

execute "add user #{user}" do
  command ['/usr/sbin/sysadminctl', *admin_credentials, '-addUser', user]
  not_if { ::File.exist?(user_home) && user_already_exists? }
end

macos_user 'delete a given user' do
  username user
  action :delete
end
