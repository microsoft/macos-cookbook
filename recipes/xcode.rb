xcode_version = node['macos']['xcode']['version']
xcode_user = node['macos']['admin_user']
xcode_path = '/Applications/Xcode.app'

developer_creds = {
  'XCODE_INSTALL_USER' => data_bag_item('credentials', 'apple_id')['apple_id'],
  'XCODE_INSTALL_PASSWORD' => data_bag_item('credentials', 'apple_id')['password'],
}

gem_package 'xcode-install'

ruby_block do
  block do
    xcversion_output = shell_out!('/usr/local/bin/xcversion installed').stdout.split
    installed_xcodes = xcversion_output.values_at(*versions.each_index.select(&:even?))
    node.default['macos']['xcode']['already_installed?'] =
      installed_xcodes.include?(node['macos']['xcode']['version'])
  end
end

execute 'xcversion_update' do
  command lazy { '/usr/local/bin/xcversion update' }
  environment developer_creds
  not_if { node['macos']['xcode']['already_installed?'] }
end

execute 'xcversion_install' do
  command lazy { "/usr/local/bin/xcversion install \"#{xcode_version}\" --no-switch" }
  environment developer_creds
  creates xcode_path
  not_if { node['macos']['xcode']['already_installed?'] }
end

execute 'xcode_select' do
  command "xcode-select -s #{xcode_path}/Contents/Developer"
  action :nothing
  subscribes :run, 'execute[xcversion_install]', :immediately
end

execute 'license' do
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
