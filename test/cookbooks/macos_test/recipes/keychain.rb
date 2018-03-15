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
