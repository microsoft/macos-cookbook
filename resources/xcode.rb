resource_name :xcode
default_action :install

property :version, String, name_property: true
property :path, String, default: '/Applications/Xcode.app'
property :simulators, Array

BASE_COMMAND = '/usr/local/bin/xcversion'.freeze

CREDENTIALS_DATA_BAG = Chef::DataBagItem.load(:credentials, :apple_id)

DEVELOPER_CREDENTIALS = {
  'XCODE_INSTALL_USER' => CREDENTIALS_DATA_BAG['apple_id'],
  'XCODE_INSTALL_PASSWORD' => CREDENTIALS_DATA_BAG['password'],
}.freeze

action :install do
  Chef::Log.info('Installing xcode-install gem')
  gem_package 'xcode-install'

  Chef::Log.debug('Reading currently available versions from Apple')
  execute 'get Xcode versions currently available from Apple' do
    command "#{BASE_COMMAND} update"
    environment DEVELOPER_CREDENTIALS
    not_if { already_installed?(new_resource.version) }
  end

  Chef::Log.info("Installing requested Xcode version: #{new_resource.version} at #{new_resource.path}")
  execute 'installed requested Xcode' do
    command "#{BASE_COMMAND} install '#{new_resource.version}'"
    environment DEVELOPER_CREDENTIALS
    creates new_resource.path
    not_if { already_installed?(new_resource.version) }
    live_stream true
  end

  Chef::Log.debug('Accepting Xcode license')
  execute 'accept Xcode license' do
    command '/usr/bin/xcodebuild -license accept'
  end
end

def already_installed?(version)
  xcversion_output = shell_out!("#{BASE_COMMAND} installed").stdout.split
  installed_xcodes = xcversion_output.values_at(*xcversion_output.each_index.select(&:even?))
  installed_xcodes.include?(version)
  Chef::Log.warn("Xcode #{version} is already installed.")
end
