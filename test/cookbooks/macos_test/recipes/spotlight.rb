if node['platform_version'].match?(/10.13/)
  execute 'create test disk collection on APFS' do
    command ['diskutil', 'apfs', 'resizeContainer',
             'disk0s2', '25g',
             'jhfs+', 'test_disk1', '1G',
             'jhfs+', 'TDD2', '1G',
             'jhfs+', 'Macintosh TD', '1G',
             'jhfs+', 'TDD-ROM', '700MB']
    not_if ['ls', '/Volumes/test_disk1']
  end

else
  execute 'create test disk collection on HFS' do
    command ['diskutil', 'resizeVolume',
             'disk0s2', '25g',
             'jhfs+', 'test_disk1', '1G',
             'jhfs+', 'TDD2', '1G',
             'jhfs+', 'Macintosh TD', '1G',
             'jhfs+', 'TDD-ROM', '700MB']
    not_if ['ls', '/Volumes/test_disk1']
  end
end

spotlight '/'

spotlight 'test_disk1' do
  indexed false
end

spotlight 'enable indexing on TDD2' do
  volume 'TDD2'
  indexed true
end

spotlight 'disable indexing on Macintosh TD' do
  volume 'Macintosh TD'
  indexed false
end

spotlight 'disable indexing and prevent searching index on TDD-ROM' do
  volume 'TDD-ROM'
  indexed false
  searchable false
end
