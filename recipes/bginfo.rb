bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = '/tmp/bginfo_src'
bginfo_home = '/Users/Shared/BGInfo'

ruby_block 'determine BGInfo owner' do
  block do
    node.default['bginfo']['owner'] =
      shell_out!('defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser').stdout.strip
  end
end

package 'imagemagick'
package 'ghostscript'

git 'BGInfo Repo' do
  repository bginfo_repo
  destination bginfo_src
  action :sync
end

execute 'BGInfo Installer' do
  command "#{bginfo_src}/setup.command"
end

directory bginfo_home do
  owner user lazy { node['bginfo']['owner'] }
  recursive true
end

bginfo_home_contents = %w(bginfo.command
                          macstorage.sh
                          final_bg.gif
                          storage.rb)

bginfo_home_contents.each do |file|
  file "#{bginfo_home}/#{file}" do
    owner user lazy { node['bginfo']['owner'] }
  end
end
