foobar_pem_path = '/Users/vagrant/foobar.pem'
foobar_cer_path = '/Users/vagrant/foobar.cer'

cookbook_file '/Users/vagrant/Test.p12' do
  action :create
  source 'Test.p12'
end

keychain 'test' do
  path '/Users/vagrant/Library/Keychains/test.keychain'
  password 'test'
  action :create
end

openssl_x509_certificate foobar_pem_path do
  common_name 'www.f00bar.com'
  org 'Foo Bar'
  org_unit 'Lab'
  country 'US'
end

execute 'convert .pem certificate to .cer certificate' do
  command ['/usr/bin/openssl', 'x509', '-inform', 'PEM', '-in', foobar_pem_path, '-outform', 'DER', '-out', foobar_cer_path]
  only_if { ::File.exist? foobar_pem_path }
end

certificate 'install a .cer format certificate file' do
  path foobar_cer_path
  keychain '/Users/vagrant/Library/Keychains/login.keychain'
  keychain_password 'vagrant'
  apps ['/Applications/Numbers.app']
  action :install
end

certificate 'install a PFX format certificate file' do
  path '/Users/vagrant/Test.p12'
  password 'test'
  keychain '/Users/vagrant/Library/Keychains/test.keychain'
  keychain_password 'test'
  apps ['/Applications/Safari.app']
  action :install
end
