resource_name :macos_user
default_action :create

property :username, String
property :password, String, default: 'password'
property :autologin, [TrueClass]
property :admin, [TrueClass]

action_class do
  def user_home
    File.join('/Users', new_resource.username)
  end

  def setup_assistant_plist
    File.join(user_home, '/Library/Preferences/com.apple.SetupAssistant.plist')
  end

  def setup_assistant_keypair_values
    { 'DidSeeSiriSetup' => true,
      'DidSeeCloudSetup' => true,
      'LastSeenCloudProductVersion' => node['platform_version'] }
  end

  def sysadminctl
    '/usr/sbin/sysadminctl'
  end

  def admin_user?
    if property_is_set?(:admin)
      '-admin'
    else
      ''
    end
  end
end

action :create do
  execute "add user #{new_resource.username}" do
    command "#{sysadminctl} -addUser #{new_resource.username} -password #{new_resource.password} #{admin_user?}"
    not_if { File.exist? build_user_home }
  end

  if property_is_set?(:autologin)
    setup_assistant_keypair_values.each do |key, setting|
      plistbuddy setup_assistant_plist do
        entry key
        value setting
      end
    end

    defaults '/Library/Preferences/com.apple.loginwindow' do
      settings 'autoLoginUser' => new_resource.username
    end

    cookbook_file '/etc/kcpassword' do
      source 'kcpassword'
      owner 'root'
      group 'wheel'
      mode '0600'
    end
  end
end

action :delete do
  directory user_home do
    recursive true
    action :delete
    only_if { ::File.exist? user_home }
  end

  execute "delete user: #{user}" do
    command "#{sysadminctl} -deleteUser #{new_resource.username}"
    only_if { "/usr/bin/dscl . -list /users | grep ^#{new_resource.username}$" }
  end
end
