execute 'add user for deletion' do
  command ['/usr/sbin/sysadminctl', '-addUser', 'delete_me']
end

macos_user 'delete a given user' do
  username 'delete_me'
  action :delete
end

macos_user 'create admin user with autologin' do
  username 'randall'
  password 'correct-horse-battery-staple'
  autologin true
  admin true
  groups 'alpha'
end

macos_user 'create non-admin user with groups' do
  username 'johnny'
  fullname 'Johnny Appleseed'
  password 'yang-yolked-cordon-karate'
  groups ['alpha', 'beta']
end

macos_user 'create non-admin without groups' do
  username 'paul'
  password 'bacon-saffron-doormat-educe'
end

macos_user 'create hidden user' do
  username 'griffin'
  password 'wells'
  hidden true
end

macos_user 'create user with secure token' do
  username 'jung'
  password 'philemon'
  secure_token true
  existing_token_auth({ username: 'vagrant', password: 'vagrant' })
end

macos_user 'create user initially with secure token' do
  username 'ray'
  password 'leah'
  secure_token true
  existing_token_auth({ username: 'vagrant', password: 'vagrant' })
end

macos_user "remove existing user's secure token" do
  username 'ray'
  password 'leah'
  secure_token false
  existing_token_auth({ username: 'vagrant', password: 'vagrant' })
end
