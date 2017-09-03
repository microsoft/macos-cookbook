auto_login_user = shell_out!('defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser').stdout.strip
bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = "/Users/#{auto_login_user}/bginfo_src"
bginfo_home = '/Users/Shared/BGInfo'

include_recipe 'homebrew'

git 'BGInfo Repo' do
  repository bginfo_repo
  destination bginfo_src
  user auto_login_user
  action :sync
end

execute 'BGInfo Installer' do
  command "#{bginfo_src}/setup.command #{node['macos']['admin_password']}"
  user auto_login_user
end

directory bginfo_home do
  owner auto_login_user
  recursive true
end

bginfo_home_contents = %w(bginfo.command
                          macstorage.sh
                          final_bg.gif
                          storage.rb)

bginfo_home_contents.each do |file|
  file "#{bginfo_home}/#{file}" do
    owner auto_login_user
  end
end
