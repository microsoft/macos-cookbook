title 'users & groups'

control 'admin-user' do
  title 'added with administrator priviledges'
  desc 'Verify the added users exist and is the autologin user'

  describe user('randall') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/randall' }
    its('groups') { should include 'alpha' }
    its('groups') { should include  'staff' }
    its('groups') { should include  'admin' }
  end

  describe command('su -l randall -c "id -G"') do
    its('stdout.split') { should include '80' }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :autoLoginUser' /Library/Preferences/com.apple.loginwindow.plist") do
    its('exit_status') { should eq 0 }
    its('stdout.chomp') { should eq 'randall' }
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
    its('uid') { should eq 504 }
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
    its('uid') { should eq 505 }
    its('groups') { should include 'staff' }
    its('groups') { should_not include  'admin' }
    its('home') { should eq '/Users/paul' }
  end

  describe command('su -l paul -c "id -G"') do
    its('stdout.split') { should_not include '80' }
  end
end
