title 'users & groups'

control 'admin-user' do
  title 'added with administrator priviledges'
  desc 'Verify the added users exist and is the autologin user'

  describe user('randall') do
    it { should exist }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/randall' }
    its('groups') { should include 'alpha' }
    its('groups') { should include  'staff' }
    its('groups') { should include  'admin' }
  end

  describe command('su -l randall -c "id -G"') do
    its('stdout.split') { should include '80' }
  end

  setup_assistant_keypair_values = { 'autoLoginUser' => 'randall',
                                     'lastUser' => 'loggedIn',
                                   }
  setup_assistant_keypair_values.each do |key, expected_value|
    describe command("/usr/libexec/Plistbuddy -c 'Print #{key}' /Library/Preferences/com.apple.loginwindow.plist") do
      its('stdout.chomp') { should eq expected_value }
    end
  end

  login_window_keypair_values = { 'DidSeeCloudSetup' => true,
                                  'DidSeeSiriSetup' => true,
                                  'DidSeePrivacy' => true,
                                }
  login_window_keypair_values.each do |key, expected_value|
    describe command("/usr/libexec/Plistbuddy -c 'Print #{key}' /Users/randall/Library/Preferences/com.apple.SetupAssistant.plist") do
      its('stdout.chomp') { should eq expected_value.to_s }
    end
  end

  describe groups.where { name == 'admin' } do
    it { should exist }
    its('gids') { should include 80 }
  end
end

control 'standard-user' do
  title 'added without administrator priviledges'
  desc 'Verify the new standard users exist without autologin and a full name'

  describe user('johnny') do
    it { should exist }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/johnny' }
    its('groups') { should include 'staff' }
    its('groups') { should include 'alpha' }
    its('groups') { should include 'beta' }
    its('groups') { should_not include  'admin' }
  end

  describe command('su -l johnny -c "id -G"') do
    its('stdout.split') { should_not include '80' }
  end

  describe command('dscl . read /Users/johnny RealName') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/RealName:/) }
    its('stdout') { should match(/Johnny Appleseed/) }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :autoLoginUser' /Library/Preferences/com.apple.loginwindow.plist") do
    its('exit_status') { should eq 0 }
    its('stdout.chomp') { should_not eq 'johnny' }
  end

  describe user('paul') do
    it { should exist }
    its('groups') { should include 'staff' }
    its('groups') { should_not include  'admin' }
    its('home') { should eq '/Users/paul' }
  end

  describe command('su -l paul -c "id -G"') do
    its('stdout.split') { should_not include '80' }
  end
end

control 'hidden-user' do
  title 'added as a hidden user'
  desc 'Verify that a standard user is hidden'

  describe user('griffin') do
    it { should exist }
    its('home') { should eq '/var/griffin' }
  end

  describe command("/usr/libexec/Plistbuddy -c 'Print IsHidden' /var/db/dslocal/nodes/Default/users/griffin.plist") do
    its('stdout') { should match(/1/) }
  end

  describe directory('/var/griffin') do
    it { should exist }
  end
end

control 'test-user' do
  title 'Checks that a user does not exist'
  desc 'Given a previously added user, check that its deletion results in user no longer being in existence.'

  describe user('test_user').exists? do
    it { should eq false }
  end
end
