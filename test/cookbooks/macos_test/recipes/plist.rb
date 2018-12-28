macoscookbook_plist = '/Users/vagrant/com.microsoft.macoscookbook.plist'
macoscookbook_test_plist = '/Users/vagrant/macoscookbookTest.plist'

plist 'create a plist that does not exist to test plist creation' do
  path macoscookbook_plist
  entry 'PokeballEatenByDog'
  value true
  owner 'vagrant'
  group 'staff'
  encoding 'us-ascii'
  mode '0600'
end

plist 'add another value to the new plist' do
  path macoscookbook_plist
  entry 'CaughtEmAll'
  value false
  owner 'vagrant'
  group 'staff'
  encoding 'us-ascii'
end

plist 'create a plist that does not exist to test plist owner' do
  path macoscookbook_test_plist
  entry 'User plist'
  value true
  owner 'vagrant'
  group 'staff'
  encoding 'us-ascii'
  mode '0644'
end

plist 'add another value to the new plist with updated mode' do
  path macoscookbook_test_plist
  entry 'User plist'
  value false
  encoding 'us-ascii'
  mode '0600'
end
