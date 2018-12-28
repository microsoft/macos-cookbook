dock_plist = '/Users/vagrant/Library/Preferences/com.apple.dock.plist'

plist 'show hidden files' do
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  owner 'vagrant'
  group 'staff'
end

plist 'put the Dock on the left side' do
  path dock_plist
  entry 'orientation'
  value 'left'
  owner 'vagrant'
  group 'staff'
end

plist 'disable window animations and Get Info animations' do
  path dock_plist
  entry 'DisableAllAnimations'
  value true
  owner 'vagrant'
  group 'staff'
end
