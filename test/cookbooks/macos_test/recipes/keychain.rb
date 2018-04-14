keychain 'create test keychain' do
  kc_file '/Users/vagrant/Library/Keychains/test.keychain'
  kc_passwd 'test'
  action :create
end

keychain 'unlock test keychain' do
  kc_file '/Users/vagrant/Library/Keychains/test.keychain'
  kc_passwd 'test'
  action :unlock
end

macos_user 'create admin user' do
  username 'testuser'
  password 'testuser'
  admin true
  action :create
end

kcfile = '/Users/testuser/Library/Keychains/login.keychain-db'

keychain 'create login keychain' do
  kc_file kcfile
  kc_passwd 'testuser'
  action :create
end
