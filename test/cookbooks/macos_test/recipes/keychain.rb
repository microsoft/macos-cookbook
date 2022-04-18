keychain 'create test keychain' do
  path '/Users/vagrant/Library/Keychains/test.keychain'
  password 'test'
  action :create
end

keychain 'unlock test keychain' do
  path '/Users/vagrant/Library/Keychains/test.keychain'
  password 'test'
  action :unlock
end

macos_user 'create admin user' do
  username 'testuser'
  password 'testuser'
  admin true
  action :create
end

kcfile = '/Users/testuser/Library/Keychains/login.keychain'

keychain 'create login keychain' do
  path kcfile
  password 'testuser'
  action :create
end
