require 'spec_helper'

shared_examples 'managing spotlight' do |macos_version|
  platform 'mac_os_x', macos_version

  recipe do
    spotlight '/' do
      indexing :enabled
    end

    spotlight '/Volumes/Data' do
      indexing :disabled
    end
  end
end

shared_context 'indexing enabled on all volumes' do
  stubs_for_resource('spotlight[/Volumes/Data]') do |resource|
    allow(resource).to receive_shell_out('/usr/bin/mdutil -s /Volumes/Data', stdout: "/Volumes/Data:\n\tIndexing enabled. \n")
  end

  stubs_for_resource('spotlight[/]') do |resource|
    allow(resource).to receive_shell_out('/usr/bin/mdutil -s /', stdout: "/:\n\tIndexing enabled. \n")
  end
end

shared_context 'indexing disabled on all volumes' do
  stubs_for_resource('spotlight[/Volumes/Data]') do |resource|
    allow(resource).to receive_shell_out('/usr/bin/mdutil -s /Volumes/Data', stdout: "/Volumes/Data:\n\tIndexing disabled. \n")
  end

  stubs_for_resource('spotlight[/]') do |resource|
    allow(resource).to receive_shell_out('/usr/bin/mdutil -s /', stdout: "/:\n\tIndexing disabled. \n")
  end
end

describe 'macos::spotlight' do
  step_into :spotlight
  macos_versions = ['10.12', '10.13']

  macos_versions.each do |macos_version|
    context 'if Spotlight indexing is enabled' do
      include_examples 'managing spotlight', macos_version
      include_context 'indexing enabled on all volumes'

      it 'does not enable spotlight on /' do
        is_expected.to_not run_execute('/usr/bin/mdutil -i on /')
      end

      it 'disables spotlight on /Volumes/Data' do
        is_expected.to run_execute('/usr/bin/mdutil -i off /Volumes/Data')
      end
    end

    context 'if Spotlight indexing is already disabled' do
      include_examples 'managing spotlight', macos_version
      include_context 'indexing disabled on all volumes'

      it 'enables spotlight on /' do
        is_expected.to run_execute('/usr/bin/mdutil -i on /')
      end

      it 'does not disable spotlight on /Volumes/Data' do
        is_expected.to_not run_execute('/usr/bin/mdutil -i off /Volumes/Data')
      end
    end
  end
end
