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
  groups %w(alpha beta)
end

macos_user 'create non-admin without groups' do
  username 'paul'
  password 'bacon-saffron-doormat-educe'
end

macos_user 'create test' do
  username 'griffin'
  password 'wells'
  hidden true
end
