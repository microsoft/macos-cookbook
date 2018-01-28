require 'spec_helper'
include MacOS

describe MacOS::MetadataUtil do
  context 'when passed a root volume that has indexing enabled' do
    before do
      allow_any_instance_of(MacOS::MetadataUtil).to receive(:volume_current_state)
        .and_return('Indexing enabled.')
    end
    it 'returns an array containing the mdutil flags matching that state' do
      md = MacOS::MetadataUtil.new('/')
      expect(md.status_flags).to eq ['on', '/', '']
    end
  end

  context 'when passed a test volume that has indexing disabled' do
    before do
      allow_any_instance_of(MacOS::MetadataUtil).to receive(:volume_current_state)
        .and_return('Indexing disabled.')
    end
    it 'returns an array containing the mdutil flags matching that state' do
      md = MacOS::MetadataUtil.new('/Volumes/test_disk1')
      expect(md.status_flags).to eq ['off', '/Volumes/test_disk1', '']
    end
  end

  context 'when passed a test volume that has indexing enabled' do
    before do
      allow_any_instance_of(MacOS::MetadataUtil).to receive(:volume_current_state)
        .and_return('Indexing enabled.')
    end
    it 'returns an array containing the mdutil flags matching that state' do
      md = MacOS::MetadataUtil.new('/Volumes/TDD2')
      expect(md.status_flags).to eq ['on', '/Volumes/TDD2', '']
    end
  end

  context 'when passed a test volume that has escape characters and indexing disabled' do
    before do
      allow_any_instance_of(MacOS::MetadataUtil).to receive(:volume_current_state)
        .and_return('Indexing disabled.')
    end
    it 'returns an array containing the mdutil flags matching that state' do
      md = MacOS::MetadataUtil.new('/Volumes/Macintosh\ TD')
      expect(md.status_flags).to eq ['off', '/Volumes/Macintosh\ TD', '']
    end
  end

  context 'when passed a test volume that has indexing and searching disabled' do
    before do
      allow_any_instance_of(MacOS::MetadataUtil).to receive(:volume_current_state)
        .and_return('Indexing and searching disabled.')
    end
    it 'returns an array containing the mdutil flags matching that state' do
      md = MacOS::MetadataUtil.new('/Volumes/TDD-ROM')
      expect(md.status_flags).to eq ['off', '/Volumes/TDD-ROM', '-d']
    end
  end
end
