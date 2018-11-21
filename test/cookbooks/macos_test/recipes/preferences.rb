plist 'show hidden files' do
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
  owner 'vagrant'
  group 'staff'
end

plist 'put the Dock on the left side' do
  path '/Users/vagrant/Library/Preferences/com.apple.dock.plist'
  entry 'orientation'
  value 'left'
  owner 'vagrant'
  group 'staff'
end

plist 'disable window animations and Get Info animations' do
  path '/Users/vagrant/Library/Preferences/com.apple.dock.plist'
  entry 'DisableAllAnimations'
  value true
  owner 'vagrant'
  group 'staff'
end

plist 'create a plist that does not exist to test plist creation' do
  path '/Users/vagrant/com.microsoft.macoscookbook.plist'
  entry 'PokeballEatenByDog'
  value true
  owner 'vagrant'
  group 'staff'
  encoding 'ascii'
end

plist 'add another value to the new plist' do
  path '/Users/vagrant/com.microsoft.macoscookbook.plist'
  entry 'CaughtEmAll'
  value false
  owner 'vagrant'
  group 'staff'
  encoding 'ascii'
end
