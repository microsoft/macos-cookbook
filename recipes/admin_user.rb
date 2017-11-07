execute "add user #{build_username}" do
  command "sysadminctl -addUser #{build_username} -password #{build_password} -admin"
  not_if { File.exist? build_user_home }
end

setup_assistant_plist = "#{build_user_home}/Library/Preferences/com.apple.SetupAssistant.plist"

setup_assist_pairs = { 'DidSeeSiriSetup' => true,
                       'DidSeeCloudSetup' => true,
                       'LastSeenCloudProductVersion' => '10.12.6' }

setup_assist_pairs.each do |key, setting|
  plistbuddy setup_assistant_plist do
    entry key
    value setting
  end
end

defaults '/Library/Preferences/com.apple.loginwindow' do
  settings 'autoLoginUser' => build_username
end

cookbook_file '/etc/kcpassword' do
  source 'kcpassword'
  owner 'root'
  group 'wheel'
  mode '0600'
end

%w(bud codesigner).each do |user|
  directory "/Users/#{user}" do
    recursive true
    action :delete
    only_if { ::File.exist? "/Users/#{user}" }
  end

  execute "delete user: #{user}" do
    command "/usr/sbin/sysadminctl -deleteUser #{user}"
    only_if "/usr/bin/dscl . -list /users | grep ^#{user}$"
  end
end
