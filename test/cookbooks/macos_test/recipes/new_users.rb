macos_user 'create admin user randall and enable automatic login' do
  username 'randall'
  password 'correct-horse-battery-staple'
  autologin true
  admin true
  groups 'alpha'
end

macos_user 'create non-admin user johnny' do
  username 'johnny'
  fullname 'Johnny Appleseed'
  password 'yang-yolked-cordon-karate'
  groups %w(alpha beta)
end

macos_user 'create non-admin user paul' do
  username 'paul'
  password 'yang-yolked-cordon-karate'
end
