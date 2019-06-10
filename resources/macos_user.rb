resource_name :macos_user
default_action :create

property :username, String, name_property: true
property :password, String, default: 'password'
property :autologin, true
property :admin, true
property :fullname, String
property :skip_setup_assistant, [true, false], default: true
property :groups, [Array, String]
property :hidden, [true, false], default: false
property :home
property :hint
property :picture
property :shell_out
property :uid

load_current_value do |desired|
  username desired if user_already_exists?
  hidden user_is_hidden?
end

action_class do
  def user_home
    ::File.join '/', 'Users', new_resource.username
  end

  def user_hidden_home
    ::File.join '/', 'var', new_resource.username
  end

  def user_sharepoints
    ::File.join '/', 'SharePoints', new_resource.username
  end

  def setup_assistant_plist
    ::File.join user_home, 'Library', 'Preferences', 'com.apple.SetupAssistant.plist'
  end

  def login_window_plist
    ::File.join '/', 'Library', 'Preferences', 'com.apple.loginwindow.plist'
  end

  def setup_assistant_keypair_values
    {
      'DidSeeCloudSetup' => true,
      'DidSeeSiriSetup' => true,
      'DidSeePrivacy' => true,
      'LastSeenCloudProductVersion' => node['platform_version'],
      'LastSeenBuddyBuildVersion' => node['platform_build'],
    }
  end

  def login_window_keypair_values
    {
      'autoLoginUser' => new_resource.username,
      'lastUser' => 'loggedIn',
    }
  end

  def sysadminctl
    '/usr/sbin/sysadminctl'
  end

  def dscl
    '/usr/bin/dscl'
  end

  def user_fullname
    new_resource.property_is_set?(:fullname) ? ['-fullName', new_resource.fullname] : new_resource.username.upcase
  end

  def admin_credentials
    admin_credentials = ['-adminUser', node['macos']['admin_user'], '-adminPassword', node['macos']['admin_password']]
    mac_os_x_after_or_at_high_sierra? ? admin_credentials : ''
  end

  def admin_user
    new_resource.property_is_set?(:admin) ? '-admin' : ''
  end

  def installer_configuration_file_content
    {
      'Users': [
        {
          admin: new_resource.admin,
          autologin: new_resource.autologin,
          skipMiniBuddy: new_resource.skip_setup_assistant,
          fullName: new_resource.fullname,
          shortName: new_resource.username,
          password: new_resource.password,
        },
      ],
    }.to_plist
  end

  def user_already_exists?
    dscl_list_users_cmd = shell_out '/usr/bin/dscl . -list /users'
    all_users = dscl_list_users_cmd.stdout.lines
    all_users.include?(new_resource.username) && ::File.exist?(user_home)
  end
end

action :create do
  converge_if_changed :username do
    file '/var/db/.InstallerConfiguration' do
      content installer_configuration_file_content
      not_if { ::File.exist? '/var/db/.AppleSetupDone' }
    end

    execute [sysadminctl, *admin_credentials, '-addUser', new_resource.username, *user_fullname, '-password', new_resource.password, admin_user]
  end

  converge_if_changed :hidden do
    execute [dscl, '.', 'create', user_home, 'IsHidden', '1']

    ruby_block "hide user #{new_resource.username} home directory #{user_home}" do
      block do
        FileUtils.mkdir_p user_hidden_home
        FileUtils.cp_r(Dir[user_home.to_s], Dir[user_hidden_home.to_s])
      end
    end

    execute 'update user record' do
      command [dscl, '.', 'create', user_home, 'NFSHomeDirectory', user_hidden_home]
      only_if { ::File.exist?(user_hidden_home) && ::File.exist?(user_home) }
    end

    execute 'remove Public Folder share point' do
      command [dscl, '.', 'delete', user_sharepoints]
      only_if { ::File.exist?(user_sharepoints) }
    end
  end

  if new_resource.property_is_set?(:autologin)
    setup_assistant_keypair_values.each do |e, v|
      plist setup_assistant_plist do
        entry e
        value v
      end
    end

    login_window_keypair_values.each do |e, v|
      plist login_window_plist do
        entry e
        value v
      end
    end

    file '/etc/kcpassword' do
      content kcpassword_hash(new_resource.password)
      owner 'root'
      group 'wheel'
      mode '0600'
    end
  end

  if new_resource.property_is_set?(:groups)
    if new_resource.groups.is_a? String
      group new_resource.groups do
        action :create
        members new_resource.username
        append true
      end
    else
      new_resource.groups.each do |g|
        group g do
          action :create
          members new_resource.username
          append true
        end
      end
    end
  end
end

action :delete do
  directory user_home do
    recursive true
    action :delete
    only_if { ::File.exist? user_home }
  end

  execute "delete user: #{new_resource.username}" do
    command [sysadminctl, '-deleteUser', new_resource.username]
    only_if { user_already_exists? }
  end
end
