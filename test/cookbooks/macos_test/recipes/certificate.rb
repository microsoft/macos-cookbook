
cookbook_file '/Users/vagrant/Test.p12' do
  action :create
  source 'Test.p12'
end

certificate 'install a PFX format certificate file' do
  certfile '/Users/vagrant/Test.p12'
  cert_password 'test'
  keychain '/Users/vagrant/Library/Keychains/login.keychain'
  apps ['/Applications/Mail.app', '/Applications/App Store.app']
  action :install
end
