default_ds_node_root = '/private/var/db/dslocal/nodes/Default'
ssh_access_group_plist = "#{default_ds_node_root}/groups/com.apple.access_ssh.plist"
crashreporter_support = '/Library/Application Support/CrashReporter'
crashreporter_diag_plist = "#{crashreporter_support}/DiagnosticMessagesHistory.plist"
current_version = Gem::Version.new node['platform_version']
yosemite = Gem::Version.new '10.10'

include_recipe 'macos::keep_awake'
include_recipe 'sudo::default'

macos_user "create user #{node['macos']['admin_user']} with autologin" do
  username node['macos']['admin_user']
  password node['macos']['admin_user']
  groups node['macos']['admin_user']
  autologin true
  admin true
end

directory 'ssh home directory' do
  path ::File.join(ENV['HOME'], '.ssh')
  user node['macos']['admin_user']
  owner node['macos']['admin_user']
  mode 0o700
end

plist ssh_access_group_plist do
  entry 'groupmembers'
  value ['501']
end

plist ssh_access_group_plist do
  entry 'users'
  value [node['macos']['admin_user']]
end

plist '/private/etc/RemoteManagement.launchd' do
  entry 'naprivs'
  value ['-1073741569']
end

plist '/Library/Preferences/com.apple.RemoteManagement.plist' do
  entry 'ARD_AllLocalUsersPrivs'
  value '-1073741569'
end

plist '/Library/Preferences/com.apple.RemoteManagement.plist' do
  entry 'ARD_AllLocalUsers'
  value false
end

plist '/private/var/db/com.apple.xpc.launchd/disabled.plist' do
  entry 'com.openssh.sshd'
  value false
  only_if { current_version >= yosemite }
end

plist '/private/var/db/com.apple.xpc.launchd/disabled.plist' do
  entry 'com.apple.screensharing'
  value false
  only_if { current_version >= yosemite }
end

plist '/private/var/db/launchd.db/com.apple.launchd/overrides.plist' do
  entry 'com.openssh.sshd'
  value false
  only_if { current_version < yosemite }
end

plist '/private/var/db/launchd.db/com.apple.launchd/overrides.plist' do
  entry 'com.apple.screensharing'
  value false
  only_if { current_version < yosemite }
end

directory crashreporter_support do
  mode 0o755
  owner 'root'
  group 'admin'
end

plist crashreporter_diag_plist do
  entry 'AutoSubmit'
  value false
end

plist crashreporter_diag_plist do
  entry 'AutoSubmitVersion'
  value 4
end

plist crashreporter_diag_plist do
  entry 'ThirdPartyDataSubmit'
  value false
end

plist crashreporter_diag_plist do
  entry 'ThirdPartyDataSubmitVersion'
  value 4
end

file '/private/var/db/.AppleSetupDone'
file '/private/var/db/.AppleDiagnosticsSetupDone'

launchd 'add network interface detection' do
  program_arguments ['/usr/sbin/networksetup', '-detectnewhardware']
  run_at_load true
  label 'com.github.timsutton.osx-vm-templates.detectnewhardware'
  path '/Library/LaunchDaemons/com.github.timsutton.osx-vm-templates.detectnewhardware.plist'
  mode 0o644
  owner 'root'
  group 'wheel'
end

remote_file 'add vagrant public key to authorized_keys' do
  source 'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub'
  path ::File.join ENV['HOME'], '.ssh', 'authorized_keys'
  user node['macos']['admin_user']
  owner node['macos']['admin_user']
  mode 0o600
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

file 'create file showing build time of the box' do
  path '/etc/box_build_time'
  content shell_out('date').stdout.chomp
end
