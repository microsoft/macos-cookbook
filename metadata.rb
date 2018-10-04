name 'macos'
maintainer 'Microsoft'
maintainer_email 'chef@microsoft.com'
license 'MIT'
description 'Resources for configuring and provisioning macOS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
chef_version '>= 13.0' if respond_to?(:chef_version)
version '2.7.0'

source_url 'https://github.com/Microsoft/macos-cookbook'
issues_url 'https://github.com/Microsoft/macos-cookbook/issues'

supports 'mac_os_x'
