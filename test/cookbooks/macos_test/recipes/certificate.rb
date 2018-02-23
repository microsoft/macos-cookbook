
cookbook_file '/Users/vagrant/Test.p12' do
  action :create
  source 'Test.p12'
end

execute 'unlock the keychain' do
  command 'security unlock-keychain -p vagrant'
end

certificate 'install some PFX file' do
  certfile '/Users/vagrant/Test.p12'
  password 'test'
  action :install
end
