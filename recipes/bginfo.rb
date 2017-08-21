bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = "/Users/#{node['macos']['admin_user']}/bginfo_src"

package 'imagemagick' do
  action :install
end

package 'ghostscript' do
  action :install
end

git 'BGInfo Repo' do
  repository bginfo_repo
  destination bginfo_src
  user node['macos']['admin_user']
  group node['macos']['admin_user']
  action :sync
end

execute 'BGInfo Installer' do
  command "#{bginfo_src}/setup.command #{node['macos']['admin_password']}"
  user    node['macos']['admin_user']
  creates "/Users/#{node['macos']['admin_user']}/Shared/BGInfo/"
  action  :run
end
