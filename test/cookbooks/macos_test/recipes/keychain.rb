keychain 'test keychain' do
  kc_file '/Users/vagrant/Library/Keychains/test.keychain'
  kc_passwd 'test'
  action :create
end
