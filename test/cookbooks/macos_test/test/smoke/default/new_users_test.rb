control 'new macOS users' do
  desc 'they exist with the expected characteristics'

  describe user('randall') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/randall' }
  end

  describe user('johnny') do
    it { should exist }
    its('uid') { should eq 504 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/johnny' }
  end

  realname_cmd = 'dscl . read /Users/johnny RealName | grep -v RealName | cut -c 2-'

  describe command(realname_cmd) do
    its('stdout.strip') { should eq 'Johnny Appleseed' }
  end
end
