macos_user 'create admin user john and enable autologin' do
  user 'john'
  autologin true
  admin true
end

macos_user 'create non-admin user john jr' do
  user 'john_jr'
end
