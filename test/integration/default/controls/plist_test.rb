
control 'plist-creation' do
    title 'arbitrary plist creation'
    desc 'creation and modification of a property list'
  
    macos_cookbook_plist = '/Users/vagrant/com.microsoft.macoscookbook.plist'
  
    describe command("/usr/libexec/PlistBuddy -c 'Print :PokeballEatenByDog' #{macos_cookbook_plist}") do
      its('stdout') { should match 'true' }
    end
  
    describe command("/usr/libexec/PlistBuddy -c 'Print :CaughtEmAll' #{macos_cookbook_plist}") do
      its('stdout') { should match 'false' }
    end
  
    describe file(macos_cookbook_plist) do
      its('owner') { should eq 'vagrant' }
      its('group') { should eq 'staff' }
      its('mode') { should cmp '0600' }
    end
  end
  
control 'plist-creation-test' do
  title 'arbitrary plist creation'
  desc 'creation and modification of a property list'

  describe file(macos_cookbook_plist) do
    its('owner') { should eq 'vagrant' }
    its('group') { should eq 'staff' }
    its('mode') { should cmp '0600' }
  end

  describe file(macos_cookbook_test_plist) do
    its('owner') { should eq 'root' }
    its('group') { should eq 'wheel' }
    its('mode') { should cmp '0600' }
  end
end
