name 'macos_test'
maintainer 'Microsoft'
maintainer_email 'chef@microsoft.com'
description 'The testing/example cookbook for the macOS cookbook recipes and custom resources.'
chef_version '>= 13.0' if respond_to?(:chef_version)
version '1.0.1'

depends 'macos'
