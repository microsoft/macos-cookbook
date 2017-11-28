control 'new macOS users' do
  desc 'they exist with the expected properties'

  describe user('john') do
    it { should exist }
    its('uid') { should eq 503 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/john' }
  end

  describe user('john_jr') do
    it { should exist }
    its('uid') { should eq 504 }
    its('gid') { should eq 20 }
    its('home') { should eq '/Users/john_jr' }
  end
end
