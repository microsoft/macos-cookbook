xcode_version = node['macos']['xcode']['version']
xcode_user = node['macos']['admin_user']
xcode_path = '/Applications/Xcode.app'

developer_creds = {
  'XCODE_INSTALL_USER' => data_bag_item('credentials', 'apple_id')['apple_id'],
  'XCODE_INSTALL_PASSWORD' => data_bag_item('credentials', 'apple_id')['password'],
}

gem_package 'xcode-install'

ruby_block 'determine if requested Xcode is already installed' do
  block do
    xcversion_output = shell_out!('/usr/local/bin/xcversion installed').stdout.split
    installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
    node.default['macos']['xcode']['already_installed?'] =
      installed_xcodes.include?(node['macos']['xcode']['version'])
  end
end

execute 'get Xcode versions currently available from Apple' do
  command lazy { '/usr/local/bin/xcversion update' }
  environment developer_creds
  not_if { node['macos']['xcode']['already_installed?'] }
end

execute 'installed requested Xcode' do
  command lazy { "/usr/local/bin/xcversion install '#{xcode_version}'" }
  environment developer_creds
  creates xcode_path
  not_if { node['macos']['xcode']['already_installed?'] }
end

execute 'accept Xcode license' do
  command 'xcodebuild -license accept'
  action :nothing
  subscribes :run, 'execute[xcode_select]', :immediately
end

execute 'enable developer mode' do
  command 'DevToolsSecurity'
end

execute 'add admin user to Developer group' do
  command "dscl . append /Groups/_developer GroupMembership #{xcode_user}"
end
