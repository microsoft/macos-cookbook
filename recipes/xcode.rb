xcode '9' do
  ios_simulators %w(11 10 9)
end

# execute 'enable developer mode' do
#   command 'DevToolsSecurity'
# end
#
# ruby_block 'set xcode user to autoLoginUser' do
#   block do
#     loginwindow_plist = '/Library/Preferences/com.apple.loginwindow'
#     auto_login_user = "defaults read #{loginwindow_plist} autoLoginUser"
#     node.default['macos']['xcode']['user'] = shell_out!(auto_login_user).stdout.strip
#   end
# end
#
# execute 'add admin user to Developer group' do
#   command lazy { "dscl . append /Groups/_developer GroupMembership #{node['macos']['xcode']['user']}" }
# end
