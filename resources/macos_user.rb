resource_name :macos_user
default_action :create

property :username, String, name_property: true
property :password, String, default: 'password'
property :autologin, [TrueClass]
property :admin, [TrueClass]
property :fullname, String
property :groups, [Array, String]

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

  def user_fullname
    new_resource.property_is_set?(:fullname) ? ['-fullName', new_resource.fullname] : ''
  end

  def admin_credentials
    Gem::Version.new(node['platform_version']) >= Gem::Version.new('10.13') ? ['-adminUser', node['macos']['admin_user'], '-adminPassword', node['macos']['admin_password']] : ''
  end

  def admin_user
    if new_resource.property_is_set?(:admin)
      '-admin'
    else
      ''
    end
  end

  def user_already_exists?
    users_output = shell_out!('/usr/bin/dscl', '.', '-list', '/users').stdout
    users_output.split("\n").include?(new_resource.username)
  end
end

action :create do
  execute "add user #{new_resource.username}" do
    command [sysadminctl, *admin_credentials, '-addUser', new_resource.username, *user_fullname, '-password', new_resource.password, admin_user]
    not_if { ::File.exist?(user_home) && user_already_exists? }
  end

  sleep(0.5)

  if new_resource.property_is_set?(:autologin)
    setup_assistant_keypair_values.each do |e, v|
      plist setup_assistant_plist do
        entry e
        value v
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

  execute "delete user: #{user}" do
    command "#{sysadminctl} -deleteUser #{new_resource.username}"
    only_if { user_already_exists? }
  end
end
