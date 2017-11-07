control 'build user' do
  desc 'build user exists'

  describe user('admin') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/admin' }
  end

  describe user('bud') do
    it { should_not exist }
  end

  describe user('codesign') do
    it { should_not exist }
  end

  describe directory('/Users/bud') do
    it { should_not exist }
  end

  describe directory('/Users/codesign') do
    it { should_not exist }
  end
end
