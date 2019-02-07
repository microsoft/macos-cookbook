# frozen_string_literal: true
require_relative 'user_settings'
include UserSettingsHelpers

module VagrantHelpers
  module Vagrant
    def vagrant_executable_path
      '/opt/vagrant/bin/vagrant'
    end

    def gems(vagrant_home)
      Dir.glob ::File.join vagrant_home, 'gems', '**', '*'
    end

    def vagrant_parallels_plugin_installed?(vagrant_home, plugin_version)
      gems(vagrant_home).any? { |path| path.match?(%r{/gems/vagrant-parallels-#{plugin_version}}) }
    end

    def vagrant_installed?
      ::File.exist? vagrant_executable_path
    end

    def vagrant_expected_version_installed?(vagrant_version_output = nil, expected_version = nil)
      vagrant_version_output ||= shell_out(vagrant_executable_path, '-v').stdout
      expected_version ||= Chef.node['vagrant']['version']
      installed_version_pattern = /(\d+.\d+.\d+)/
      installed_version = installed_version_pattern.match(vagrant_version_output)
      Gem::Version.new(installed_version) == Gem::Version.new(expected_version)
    end
  end
end

Chef::Recipe.include(VagrantHelpers::Vagrant)
Chef::Resource.include(VagrantHelpers::Vagrant)
