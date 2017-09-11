xcode_version = node['macos']['xcode']['version']
admin_user = node['macos']['admin_user']
temporary_xcode_path = "/Applications/Xcode-#{xcode_version.split(' ')[0]}.app"
final_xcode_path = "/Applications/Xcode#{'-beta' if node['macos']['xcode']['beta']}.app"

environment = {
    'XCODE_INSTALL_USER' => data_bag_item('credentials', 'apple_id')['apple_id'],
    'XCODE_INSTALL_PASSWORD' => data_bag_item('credentials', 'apple_id')['password'],
}

gem_package 'xcode-install'

execute 'xcversion_update' do
  command '/usr/local/bin/xcversion update'
  environment environment
  not_if { xcode_installed? }
end

execute 'xcversion_install' do
  command "/usr/local/bin/xcversion install \"#{xcode_version}\" --no-switch"
  environment environment
  creates temporary_xcode_path
  not_if { xcode_installed? }
end

directory final_xcode_path do
  recursive true
  action :nothing
  subscribes :delete, 'execute[xcversion_install]', :immediately
end

execute "mv #{temporary_xcode_path} #{final_xcode_path}" do
  only_if "test -d #{temporary_xcode_path}"
  action :nothing
  subscribes :run, 'execute[xcversion_install]', :immediately
end

execute 'xcode_select' do
  command "xcode-select -s #{final_xcode_path}/Contents/Developer"
  action :nothing
  subscribes :run, "execute[mv #{temporary_xcode_path} #{final_xcode_path}]", :immediately
end

# xcode-install accepts the license, but fails sometimes.
execute 'license' do
  command 'xcodebuild -license accept'
  action :nothing
  subscribes :run, 'execute[xcode_select]', :immediately
end

execute 'enable developer mode' do
  command 'DevToolsSecurity'
end

execute 'add admin user to Developer group' do
  command "dscl . append /Groups/_developer GroupMembership #{admin_user}"
end
