control 'new macOS users' do
  desc 'they exist with the expected characteristics'

  describe user('randall') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/randall' }
    its('groups') { should include 'alpha' }
    its('groups') { should include  'staff' }
    its('groups') { should include  'admin' }
  end

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

  describe group('admin') do
    it { should exist }
    its('gid') { should eq 80 }
  end

  realname_cmd = 'dscl . read /Users/johnny RealName | grep -v RealName | cut -c 2-'

  describe command(realname_cmd) do
    its('stdout.strip') { should eq 'Johnny Appleseed' }
  end

  describe user('paul') do
    it { should exist }
    its('uid') { should eq 505 }
    its('groups') { should include 'staff' }
    its('groups') { should_not include  'admin' }
    its('home') { should eq '/Users/paul' }
  end

  describe command('su -l randall -c "id -G"') do
    its('stdout.split') { should include '80' }
  end

  describe command('su -l johnny -c "id -G"') do
    its('stdout.split') { should_not include '80' }
  end

  describe command('su -l paul -c "id -G"') do
    its('stdout.split') { should_not include '80' }
  end
end
