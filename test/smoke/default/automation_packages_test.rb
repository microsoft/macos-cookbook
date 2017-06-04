describe command('which /usr/local/bin/python3') do
  its('stdout') { should match('/usr/local/bin/python3') }
end

describe command('which /usr/local/bin/ifuse') do
  its('stdout') { should match('/usr/local/bin/ifuse') }
end
