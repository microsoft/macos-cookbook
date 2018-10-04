require 'spec_helper'

shared_examples 'spotlight[test]' do |macos_version, index_state, macos_directory|
  platform 'mac_os_x', macos_version
  recipe do
    spotlight 'test' do
      indexing index_state
      searchable false
      directory macos_directory
    end
  end
end

describe 'macos::spotlight' do
  step_into :spotlight
  macos_versions = ['10.12', '10.13']
  macos_directories = ['/', '/Volumes/Data', '/Volumes/os-test-fakeymcfakerton']

  macos_versions.each do |macos_version|
    macos_directories.each do |macos_directory|
      stubs_for_provider('spotlight[test]') do |provider|
        allow(provider).to receive_shell_out('/usr/bin/mdutil', '-s', macos_directory)
      end

      context 'if Spotlight indexing is enabled' do
        include_examples 'spotlight[test]', macos_version, :disabled, macos_directory
        it 'disables spotlight' do
          allow_any_instance_of(Chef::Resource::ActionClass).to receive(:index_status).and_return('Indexing enabled.')
          is_expected.to run_execute('Spotlight indexing is off')
        end
      end

      context 'if Spotlight indexing is already disabled' do
        include_examples 'spotlight[test]', macos_version, :disabled, macos_directory
        it 'does nothing' do
          allow_any_instance_of(Chef::Resource::ActionClass).to receive(:index_status).and_return('Indexing enabled.')
          is_expected.to_not run_execute('Spotlight indexing is off')
        end
      end
    end
  end
end
