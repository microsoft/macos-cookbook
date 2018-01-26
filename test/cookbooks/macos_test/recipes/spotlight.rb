execute 'create test disk collection' do
  command ['diskutil', 'resizeVolume',
           'disk0s2', '25g',
           'jhfs+', 'test_disk1', '1G',
           'jhfs+', 'TDD2', '1G',
           'jhfs+', 'Macintosh TD', '1G',
           'jhfs+', 'TDD-ROM', '700MB']
end

spotlight '/'

spotlight 'enable indexing on test_disk1' do
  volume 'test_disk1'
  indexed true
end

spotlight 'disable indexing on TDD2' do
  volume 'TDD2'
  indexed false
end

spotlight 'disable indexing and delete metadata store on Macintosh TD' do
  volume 'Macintosh TD'
  indexed false
  erase_store true
end

spotlight 'disabled indexing and prevent searching index on TDD-ROM' do
  volume 'TDD-ROM'
  indexed false
  allow_search false
end
