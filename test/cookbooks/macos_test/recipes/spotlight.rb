test_file = 'test.txt'
test_volumes = ['test_disk1', 'TDD2', 'Macintosh TD', 'TDD-ROM']

file test_file
test_volumes.each do |volume|
  execute 'create test disk collection on HFS' do
    command ['hdiutil', 'create', "#{volume}.dmg",
             '-size', '1g', '-format', 'UDRW',
             '-volname', volume, '-srcfolder', test_file,
             '-ov', '-attach']
    not_if 'diskutil info TDD-ROM'
  end
end

execute 'test' do
  command ['sudo', 'launchctl', 'unload', '-w', '/System/Library/LaunchDaemons/com.apple.metadata.mds.plist']
  not_if 'diskutil info TDD-ROM'
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
