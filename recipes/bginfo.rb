admin = node['apex_automation']['admin']

bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = "/Users/#{admin}/bginfo_src"

package 'imagemagick' do
  action :install
end

package 'ghostscript' do
  action :install
end

git 'BGInfo Repo' do
  repository bginfo_repo
  destination bginfo_src
  user admin
  group admin
  action :sync
end

execute 'BGInfo Installer' do
  command "#{bginfo_src}/setup.command #{admin_pass}"
  user    admin
  creates "/Users/#{admin}/Shared/BGInfo/"
  action  :run
end
