bginfo_repo = 'http://apexlabgit.corp.microsoft.com/mike/BG-Info-Mac.git'
bginfo_src  = '/tmp/bginfo_src'
bginfo_home = '/Users/Shared/BGInfo'

git bginfo_src do
  repository bginfo_repo
end

include_recipe 'homebrew'
package 'imagemagick'
package 'ghostscript'

ruby_block 'set BGInfo owner to autoLoginUser' do
  block do
    loginwindow_plist = '/Library/Preferences/com.apple.loginwindow'
    auto_login_user = "defaults read #{loginwindow_plist} autoLoginUser"
    node.default['bginfo']['owner'] = shell_out!(auto_login_user).stdout.strip
  end
end

directory bginfo_home do
  owner lazy { node['bginfo']['owner'] }
  recursive true
  mode 0754
end

Dir["#{bginfo_src}/*"].each do |path|
  file = path.split('/').last
  file "#{bginfo_home}/#{file}" do
    content ::File.open(path).read
    owner lazy { node['bginfo']['owner'] }
    mode 0777
  end
end

launchd 'com.microsoft.bginfo.plist' do
  program '/Users/Shared/BGInfo/bginfo.command'
  run_at_load true
  action :enable
end
