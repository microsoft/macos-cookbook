bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = '/tmp/bginfo_src'
bginfo_home = '/Users/Shared/BGInfo'

git 'BGInfo Repo' do
  repository bginfo_repo
  destination bginfo_src
end

include_recipe 'homebrew'
package 'imagemagick'
package 'ghostscript'

execute 'BGInfo Installer' do
  command "#{bginfo_src}/setup.command"
end

ruby_block 'set BGInfo owner to autoLoginUser' do
  block do
    loginwindow_plist = '/Library/Preferences/com.apple.loginwindow'
    auto_login_user = "defaults read #{loginwindow_plist} autoLoginUser"
    node.default['bginfo']['owner'] = shell_out!(auto_login_user).stdout.strip
  end
end

directory bginfo_home do
  owner user(lazy { node['bginfo']['owner'] })
  recursive true
end

bginfo_home_contents = %w(bginfo.command
                          macstorage.sh
                          final_bg.gif
                          storage.rb)

bginfo_home_contents.each do |file|
  file "#{bginfo_home}/#{file}" do
    owner user(lazy { node['bginfo']['owner'] })
  end
end
