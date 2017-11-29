resource_name :macos_user
default_action :create

property :username, String, name_property: true
property :password, String, default: 'password'
property :autologin, [TrueClass]
property :admin, [TrueClass]

action_class do
  def user_home
    ::File.join('/Users', new_resource.username)
  end

  def setup_assistant_plist
    ::File.join(user_home, '/Library/Preferences/com.apple.SetupAssistant.plist')
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
    not_if { ::File.exist? user_home }
  end

  if property_is_set?(:autologin)
    setup_assistant_keypair_values.each do |key, setting|
      plist "set #{setting} to #{key}" do
        path setup_assistant_plist
        entry key
        value setting
      end
    end

    plist "set user \"#{new_resource.username}\" to login automatically" do
      path '/Library/Preferences/com.apple.loginwindow.plist'
      entry 'autoLoginUser'
      value new_resource.username
    end

    file '/etc/kcpassword' do
      content kcpassword_hash(new_resource.password)
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
