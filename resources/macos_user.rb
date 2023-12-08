unified_mode true

provides :macos_user
default_action :create

property :username, String, name_property: true
property :password, String, sensitive: true
property :autologin, [TrueClass]
property :admin, [TrueClass]
property :fullname, String
property :groups, [Array, String]
property :hidden, [true, false], default: false
property :secure_token, [true, false], default: false
property :existing_token_auth, Hash

action_class do
  def user_home
    ::File.join('/', 'Users', new_resource.username)
  end

  def user_hidden_home
    ::File.join('/', 'var', new_resource.username)
  end

  def user_sharepoints
    ::File.join('/', 'SharePoints', new_resource.username)
  end

  def setup_assistant_plist
    ::File.join(user_home, 'Library', 'Preferences', 'com.apple.SetupAssistant.plist')
  end

  def login_window_plist
    ::File.join('/', 'Library', 'Preferences', 'com.apple.loginwindow.plist')
  end

  def setup_assistant_keypair_values
    { 'DidSeeCloudSetup' => true,
      'DidSeeSiriSetup' => true,
      'DidSeePrivacy' => true,
      'DidSeeAccessibility' => true,
      'DidSeeAppearanceSetup' => true,
      'DidSeeScreenTime' => true,
      'LastSeenCloudProductVersion' => node['platform_version'],
      'LastPreLoginTasksPerformedVersion' => node['platform_version'],
      'LastPreLoginTasksPerformedBuild' => node['platform_build'],
      'LastPrivacyBundleVersion' => '2',
      'LastSeenBuddyBuildVersion' => node['platform_build'],
      'LastSeenSiriProductVersion' => node['platform_version'],
    }
  end

  def login_window_keypair_values
    { 'autoLoginUser' => new_resource.username,
      'lastUser' => 'loggedIn',
      'autoLoginUserScreenLocked' => false,
    }
  end

  def sysadminctl
    '/usr/sbin/sysadminctl'
  end

  def dscl
    '/usr/bin/dscl'
  end

  def user_fullname
    if new_resource.property_is_set?(:fullname)
      ['-fullName', new_resource.fullname]
    else
      ''
    end
  end

  def exec_sysadminctl(args)
    shell_out!(sysadminctl, args).stderr
  end

  def logged_in?(user)
    logged_in_user = shell_out('stat', '-f', '%Su', '/dev/console').stdout.chomp
    logged_in_user == user
  end

  def validate_secure_token_modification
    if !new_resource.property_is_set?(:existing_token_auth) || !new_resource.property_is_set?(:password)
      raise "Both an existing_token_auth hash and the user password for #{new_resource.username} must be provided to modify secure token!" unless logged_in? '_mbsetupuser'
    end
  end

  def token_credentials
    if new_resource.property_is_set?(:existing_token_auth)
      ['-adminUser', new_resource.existing_token_auth[:username], '-adminPassword', new_resource.existing_token_auth[:password]]
    else
      ''
    end
  end

  def secure_token_enabled?
    shell_out!(sysadminctl, '-secureTokenStatus', new_resource.username).stderr.include?('ENABLED')
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
  if new_resource.secure_token && !property_is_set?(:existing_token_auth)
    raise "An existing_token_auth hash must be provided if you want a secure token for #{new_resource.username}!"
  end

  unless ::File.exist?(user_home) && user_already_exists?
    cmd = [*token_credentials, '-addUser', new_resource.username, *user_fullname, '-password', new_resource.password, admin_user]
    output = exec_sysadminctl(cmd)
    unless /creating user/.match?(output.downcase)
      raise "error while creating user: #{output}"
    end
  end

  if new_resource.secure_token && !secure_token_enabled?
    validate_secure_token_modification
    cmd = [*token_credentials, '-secureTokenOn', new_resource.username, '-password', new_resource.password]
    output = exec_sysadminctl(cmd)
    unless /done/.match?(output.downcase)
      raise "error while modifying SecureToken: #{output}"
    end
  end

  if !new_resource.secure_token && secure_token_enabled?
    validate_secure_token_modification
    cmd = [*token_credentials, '-secureTokenOff', new_resource.username, '-password', new_resource.password]
    output = exec_sysadminctl(cmd)
    unless /done/.match?(output.downcase)
      raise "error while modifying SecureToken: #{output}"
    end
  end

  if new_resource.hidden
    execute "hide user #{new_resource.username}" do
      key = 'IsHidden'
      desired_value = '1'
      read_command = shell_out(dscl, '.', 'read', user_home, key)
      current_value = read_command.stdout.empty? ? 0 : read_command.stdout.split(':').last.strip
      command [dscl, '.', 'create', user_home, key, desired_value]
      not_if { current_value.eql? desired_value }
    end

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
        owner new_resource.username
        group 'staff'
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
      sensitive true
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

  if user_already_exists?
    cmd = ['-deleteUser', new_resource.username]
    output = exec_sysadminctl(cmd)
    unless /deleting record|not found/.match?(output.downcase)
      raise "error deleting user: #{output}"
    end
  end
end
