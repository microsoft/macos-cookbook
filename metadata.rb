name 'macos-cookbook'
maintainer 'Copyright © 2017 Microsoft. All rights reserved.'
maintainer_email 'apxlab@microsoft.com'
license 'MIT'
description 'Installs/Configures macos-cookbook'
long_description 'Installs/Configures macos-cookbook'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/macos-cookbook/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/macos-cookbook'


depends 'homebrew'
depends 'poise-python'
depends 'chef-client'