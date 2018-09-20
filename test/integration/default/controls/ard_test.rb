title 'ard'

dscl = '/usr/bin/dscl'

control 'naprivs' do
  title 'naprivs value for remote management'
  desc 'Verify that naprivs in the users.plist has the value -1073741569'

  describe command ('#{dscl} . list /Users naprivs') do
      its('stdout') { should_match (/vagrant -1073741569/) }
  end

  describe command ("sudo -E PlistBuddy -c 'Print naprivs:0' /var/db/dslocal/nodes/Default/users/vagrant.plist") do
    its('stdout') { should_match (/-1073741569/) }
  end
end
