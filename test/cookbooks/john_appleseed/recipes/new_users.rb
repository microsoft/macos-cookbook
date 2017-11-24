macos_user 'create admin user john and enable autologin' do
  username 'john'
  password 'correct-horse-battery-staple'
  autologin true
  admin true
end

macos_user 'create non-admin user john jr' do
  username 'john_jr'
  password 'yang-yolked-cordon-karate'
end
