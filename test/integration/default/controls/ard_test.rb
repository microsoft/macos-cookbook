title 'remote access'

control 'remote-control' do
  title 'naprivs value represents remote control for all users'
  desc 'verify that naprivs has the bitmask value -1073741569'

  describe command('/usr/bin/dscl . list /Users naprivs') do
    its('stdout') { should match 'vagrant   -1073741569' }
  end
end
