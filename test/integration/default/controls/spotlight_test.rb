title 'spotlight'

control 'indexing-and-searching' do
  title 'manipulated metadata settings'
  desc 'Verify search and index settings are set correctly for various volumes'

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
