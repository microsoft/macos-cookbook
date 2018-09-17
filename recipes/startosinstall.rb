users_shared = ::File.join '/', 'Users', 'Shared'
install_macos_script = 'installinstallmacos.py'
script_source = ::File.join 'https://raw.githubusercontent.com/munki/macadmin-scripts/master', install_macos_script
script_destination = ::File.join users_shared, install_macos_script

remote_file script_destination do
  source script_source
  owner node['macos']['admin_user']
  group 'staff'
  mode '0755'
  action :create
end

execute 'download Install macOS' do
  command ['echo', '3', '|', script_destination, '--workdir', users_shared, '--raw']
  action :run
end

glob_sparse_image = ::File.join users_shared, '*.sparseimage'
mount_path = shell_out('hdiutil', 'attach', glob_sparse_image).stdout
startosinstall = shell_out('find', mount_path, '-name', 'startosinstall').stdout
