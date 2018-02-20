control 'spotlight metadata stores for mounted volumes' do
  desc 'they are set as intended by the smoke recipe'

  describe command('/usr/bin/mdutil -s /') do
    its('stdout') { should match "/:\n\tIndexing enabled." }
  end

  describe command('/usr/bin/mdutil -s /Volumes/test_disk1') do
    its('stdout') { should match "/Volumes/test_disk1:\n\tIndexing disabled." }
  end

  describe command('/usr/bin/mdutil -s /Volumes/TDD2') do
    its('stdout') { should match "/Volumes/TDD2:\n\tIndexing enabled." }
  end

  describe command('/usr/bin/mdutil -s /Volumes/Macintosh\ TD') do
    its('stdout') { should match "/Volumes/Macintosh TD:\n\tIndexing disabled." }
  end

  describe command('/usr/bin/mdutil -s /Volumes/TDD-ROM') do
    its('stdout') { should match "/Volumes/TDD-ROM:\n\tIndexing and searching disabled." }
  end
end
