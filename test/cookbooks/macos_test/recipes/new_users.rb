macos_user 'create admin user randall and enable automatic login' do
  username 'randall'
  password 'correct-horse-battery-staple'
  autologin true
  admin true
end

macos_user 'create non-admin user johnny' do
  username 'johnny'
  password 'yang-yolked-cordon-karate'
end
