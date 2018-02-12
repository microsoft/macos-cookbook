control 'new macOS users' do
  desc 'they exist with the expected characteristics'

  describe user('randall') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/randall' }
    its('groups') { should include 'alpha' }
  end

  describe user('johnny') do
    it { should exist }
    its('uid') { should eq 504 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/johnny' }
    its('groups') { should include 'alpha' }
    its('groups') { should include 'beta' }
  end

  realname_cmd = 'dscl . read /Users/johnny RealName | grep -v RealName | cut -c 2-'

  describe command(realname_cmd) do
    its('stdout.strip') { should eq 'Johnny Appleseed' }
  end

  describe user('paul') do
    it { should exist }
    its('uid') { should eq 505 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/paul' }
  end
end
