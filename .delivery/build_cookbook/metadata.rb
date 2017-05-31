name 'build_cookbook'
maintainer 'Copyright © 2017 Microsoft. All rights reserved.'
maintainer_email 'apxlab@microsoft.com'
license 'mit'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'delivery-truck'
