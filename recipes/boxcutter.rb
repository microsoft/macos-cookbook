include_recipe 'macos::keep_awake'

launchd 'add network interface detection' do
  program_arguments ['/usr/sbin/networksetup', '-detectnewhardware']
  run_at_load true
  label 'com.github.timsutton.osx-vm-templates.detectnewhardware'
  path '/Library/LaunchDaemons/com.github.timsutton.osx-vm-templates.detectnewhardware.plist'
  mode 0o644
  owner 'root'
  group 'wheel'
end

file 'create file showing build time of the box' do
  path '/etc/box_build_time'
  content shell_out('date').stdout.chomp
end

directory 'ssh home directory' do
  path ::File.join(ENV['HOME'], '.ssh')
  user node['macos']['admin_user']
  owner node['macos']['admin_user']
  mode 0o700
end

remote_file 'add vagrant public key to authorized_keys' do
  source 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub'
  path ::File.join(ENV['HOME'], '.ssh', 'authorized_keys')
  user node['macos']['admin_user']
  owner node['macos']['admin_user']
  mode 0o600
end

macos_user "create user #{node['macos']['admin_user']} with autologin" do
  username node['macos']['admin_user']
  password node['macos']['admin_user']
  autologin true
  admin true
end

group "create group #{node['macos']['admin_user']} to match user" do
  group_name node['macos']['admin_user']
  members node['macos']['admin_user']
end

machine_name 'set computer/hostname' do
  platform_and_version = [node['platform'], node['platform_version']].join('-')
  computer_name platform_and_version
  hostname platform_and_version + '.vagrantup.com'
  local_hostname platform_and_version + '.local'
end

execute 'install all available software updates' do
  command ['softwareupdate', '--install', '--all']
  live_stream true
  only_if { updates_available? }
end
