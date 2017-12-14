ard
===

`[edit on GitHub] <https://github.com/chef/chef-web-docs/blob/master/chef_master/source/resource_gem_package.rst>`__

The `ard` resource represents the current state of the "Remote Management" settings.
It uses the kickstart command with command line arguments based on the properties
set in an `ard` resource.

Syntax
------

An `ard` resource block manages a package on a node, typically by
installing it. The simplest use of the **gem_package** resource is:

.. code-block:: ruby

ard 'enable'

which will install the named package using all of the default options and the default action (``:install``).

The full syntax for all of the properties that are available to the **gem_package** resource is:

.. code-block:: ruby

   gem_package 'name' do
     clear_sources              TrueClass, FalseClass
     include_default_source     TrueClass, FalseClass
     gem_binary                 String
     notifies                   # see description
     options                    String
     package_name               String, Array # defaults to 'name' if not specified
     provider                   Chef::Provider::Package::Rubygems
     source                     String, Array
     subscribes                 # see description
     timeout                    String, Integer
     version                    String, Array
     action                     Symbol # defaults to :install if not specified
   end

where

* ``gem_package`` tells the chef-client to manage a package
* ``'name'`` is the name of the package
* ``action`` identifies which steps the chef-client will take to bring the node into the desired state
* ``clear_sources``, ``include_default_source``, ``gem_binary``, ``options``, ``package_name``, ``provider``, ``source``, ``timeout``, and ``version`` are properties of this resource, with the Ruby type shown. See "Properties" section below for more information about all of the properties that may be used with this resource.