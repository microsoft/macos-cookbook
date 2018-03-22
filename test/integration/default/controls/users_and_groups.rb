title 'users & groups'

control 'admin-user' do
  title 'added with administrator priviledges'
  desc 'Verify the added users exist and is the autologin user'

  describe user('randall') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('group') { should eq 'admin' }
    its('home') { should eq '/Users/randall' }
  end

  describe command("/usr/libexec/PlistBuddy -c 'Print :autoLoginUser' /Library/Preferences/com.apple.loginwindow.plist") do
    its('exit_status') { should eq 0 }
    its('stdout.chomp') { should eq 'randall' }
  end
end

control 'standard-user' do
  title 'added without administrator priviledges'
  desc 'Verify the new standard users exist without autologin and a full name'

  describe user('johnny') do
    it { should exist }
    its('uid') { should eq 504 }
    its('gid') { should eq 20 }
    its('group') { should_not eq 'admin' }
    its('home') { should eq '/Users/johnny' }
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
end
