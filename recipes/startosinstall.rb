users_shared = ::File.join '/', 'Users', 'Shared'
install_macos_script = 'installinstallmacos.py'
script_source = ::File.join 'https://raw.githubusercontent.com/munki/macadmin-scripts/master', install_macos_script
script_destination = ::File.join users_shared, install_macos_script

ruby_block do
  block do
    users_shared_install_macos_script = ::File.join users_shared, install_macos_script
    ::File.exist? users_shared_install_macos_script
  end
end

remote_file script_destination do
  source script_source
  owner node['macos']['admin_user']
  group 'staff'
  mode '0755'
  action :nothing
end

execute 'download Install macOS' do
  index_10_13_6_17G65 = '3'
  command ['echo', index_10_13_6_17G65, '|', script_destination, '--workdir', users_shared, '--raw']
  action :run
end

glob_sparse_image = ::File.join users_shared, '*.sparseimage'
hdiutil_attach_output = shell_out('hdiutil', 'attach', glob_sparse_image).stdout
startosinstall = shell_out('find', hdiutil_attach_output.chomp, '-name', 'startosinstall').stdout
