name 'macos'
maintainer 'Microsoft'
maintainer_email 'chef@microsoft.com'
license 'MIT'
description 'Resources for configuring and provisioning macOS'
long_description 'Resources for configuring and provisioning macOS'
chef_version '~> 13.0' if respond_to?(:chef_version)
version '0.8.3'

source_url 'https://github.com/Microsoft/macos-cookbook'
issues_url 'https://github.com/Microsoft/macos-cookbook/issues'

supports 'mac_os_x'

depends 'homebrew'
