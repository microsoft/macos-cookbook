bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = "/Users/#{node['macos']['admin_user']}/bginfo_src"
bginfo_home = '/Users/Shared/BGInfo'
include_recipe 'homebrew'
git 'BGInfo Repo' do
  repository bginfo_repo
  destination bginfo_src
  user node['macos']['admin_user']
  group node['macos']['admin_user']
  action :sync
end

execute 'BGInfo Installer' do
  command "#{bginfo_src}/setup.command #{node['macos']['admin_password']}"
  user node['macos']['admin_user']
end

auto_login_user = shell_out!('defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser').stdout.strip

directory '/Users/Shared/BGInfo' do
directory bginfo_home do
  owner auto_login_user
  recursive true
end

bginfo_files = %w(bginfo.command final_bg.gif macstorage.sh storage.rb)

bginfo_files.each do |file|
  file "/Users/Shared/BGInfo/#{file}" do
  file "#{bginfo_home}/#{file}" do
    owner auto_login_user
  end
end
