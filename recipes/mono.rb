package = node['macos']['mono']['package']
version = node['macos']['mono']['version']

remote_file "#{Chef::Config[:file_cache_path]}/#{package}" do
  source "https://download.mono-project.com/archive/#{version}/macos-10-universal/#{package}"
  checksum node['macos']['mono']['checksum']
  not_if 'pkgutil --pkgs=com.xamarin.mono-MDK.pkg'
end

execute 'install-mono' do
  command "installer -pkg #{Chef::Config[:file_cache_path]}/#{package} -target /"
  not_if 'pkgutil --pkgs=com.xamarin.mono-MDK.pkg'
end
