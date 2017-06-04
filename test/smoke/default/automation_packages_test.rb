describe command('which python3') do
  its('stdout') { should match('/usr/local/bin/python3') }
end

describe command('which ifuse') do
  its('stdout') { should match('/usr/local/bin/ifuse') }
end
