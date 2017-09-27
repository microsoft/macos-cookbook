xcode_version = node['macos']['xcode']['version']
xcversion = '/usr/local/bin/xcversion'

developer_creds = {
  'XCODE_INSTALL_USER' => data_bag_item('credentials', 'apple_id')['apple_id'],
  'XCODE_INSTALL_PASSWORD' => data_bag_item('credentials', 'apple_id')['password'],
}

gem_package 'xcode-install'

ruby_block 'determine if requested Xcode is already installed' do
  block do
    xcversion_output = shell_out!("#{xcversion} installed").stdout.split
    installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
    node.default['macos']['xcode']['already_installed?'] =
      installed_xcodes.include?(node['macos']['xcode']['version'])
  end
end

execute 'get Xcode versions currently available from Apple' do
  command lazy { "#{xcversion} update" }
  environment developer_creds
  not_if { node['macos']['xcode']['already_installed?'] }
end

execute 'installed requested Xcode' do
  command lazy { "#{xcversion} install '#{xcode_version}' --no-show-release-notes" }
  environment developer_creds
  not_if { node['macos']['xcode']['already_installed?'] }
end

execute 'accept Xcode license' do
  command 'xcodebuild -license accept'
end
