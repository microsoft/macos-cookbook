dock = "/Users/vagrant/Library/Preferences/com.apple.dock.plist"
macoscookbook = "/Users/vagrant/com.microsoft.macoscookbook.plist"

plist 'show hidden files' do
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  owner 'vagrant'
  group 'staff'
end

plist 'put the Dock on the left side' do
  path dock
  entry 'orientation'
  value 'left'
  owner 'vagrant'
  group 'staff'
end

plist 'disable window animations and Get Info animations' do
  path dock
  entry 'DisableAllAnimations'
  value true
  owner 'vagrant'
  group 'staff'
end

plist 'create a plist that does not exist to test plist creation' do
  path macoscookbook
  entry 'PokeballEatenByDog'
  value true
  owner 'vagrant'
  group 'staff'
  encoding 'ascii'
end

plist 'add another value to the new plist' do
  path macoscookbook
  entry 'CaughtEmAll'
  value false
  owner 'vagrant'
  group 'staff'
  encoding 'ascii'
end
