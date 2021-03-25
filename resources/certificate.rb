provides :certificate

property :certfile, String
property :cert_password, String
property :keychain, String, default: ''
property :apps, Array
property :source_type, String, equal_to: [:cookbook_file, :filesytem], default: :filesystem

action :install do
  if new_resource.source_type == :cookbook_file
    new_resource.certfile = ::File.join Chef::Config[:file_cache_path], new_resource.certfile

    cookbook_file destination do
      source new_resource.certfile
      action :create
    end
  end

  cert = SecurityCommand.new(new_resource.certfile, new_resource.keychain)

  execute "unlock #{new_resource.keychain}" do
    admin_password = node['macos']['admin_password']
    command cert.unlock_keychain(admin_password)
  end

  execute 'install-certificate' do
    command cert.install_certificate(new_resource.cert_password, new_resource.apps)
  end
end
