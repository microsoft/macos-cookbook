macOS Cookbook
==============

![build-status](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2140/badge)

The macOS cookbook is a Chef library cookbook that provides resources for configuring
and provisioning macOS. Additionally, it provides recipes that implement common
use-cases of the macOS cookbook's recources.

Requirements
------------

- Only tested on Chef 13
- Surprisingly, this cookbook is only compatible with macOS

Supported OS X/macOS versions
-----------------------------

- OS X El Capitan 10.11
- macOS Sierra 10.12
- macOS High Sierra 10.13

Attributes
----------

### Admin User and Password

```ruby
node['macos']['admin_user'] = 'vagrant'
node['macos']['admin_password'] = 'vagrant'
```

Each of these attributes defaults to vagrant since our resources are developed
with the Vagrant paradigm. In other words, the user and password declared here
should be an admin user with passwordless super-user rights.

Recipes
-------

### Disable Software Updates

Disables automatic checking and downloading of software updates.

**Usage:** `include_recipe macos::disable_software_updates`

No attributes used in this recipe.

### Keep Awake

Prevent macOS from falling asleep, disable the screensaver, and
several other settings to always keep macOS on. Uses the `plistbuddy` and `pmset`
resources.

**Usage:** `include_recipe macos::keep_awake`

| Attribute used                        | Default value           |
|---------------------------------------|-------------------------|
| `node['macos']['network_time_server']`| `'time.windows.com'`    |
| `node['macos']['time_zone']`          | `'America/Los_Angeles'` |

### Mono

Installs [Mono](http://www.mono-project.com/docs/about-mono/). Requires package
name, version number, and checksum in order to override.

**Usage:** `include_recipe macos::mono`

| Attribute used                      | Default value              |
|-------------------------------------|----------------------------------------|
| `node['macos']['mono']['package']`  | `'MonoFramework-MDK-4.4.2.11.macos10.xamarin.universal.pkg'` |
| `node['macos']['mono']['version']`  | `'4.4.2'`                  |
| `node['macos']['mono']['checksum']` | `'d8bfbee7ae4d0d1facaf0ddfb70c0de4b1a3d94bb1b4c38e8fa4884539f54e23'` |

### Xcode

Installs Xcode 9.1 and simulators for iOS 10 and iOS 11. Check out
the documentation for the Xcode resource if you need more flexibility.

**Usage:** `include_recipe::xcode`

| Attribute Used                                                | Default value |
|---------------------------------------------------------------|---------------|
| `node['macos']['xcode']['version']`                           |  `'9.1'`      |
| `node['macos']['xcode']['simulator']['major_version']`        | `%w(11 10)`   |

### Apple Configurator 2

Installs Apple Configurator 2 using `mas` and links `cfgutil` to
`/usr/local/bin`. Requires a `data_bag_item` containing valid App Store credentials.

**Usage:** `include_recipe::configurator`

**Attributes**: No attributes used in this recipe.

#### Required Data Bag Items

**Example:**

```json
{
  "id": "apple_id",
  "apple_id": "farva@spurbury.gov",
  "password": "0k@yN0cR34m"
}
```

Resources
---------

### Apple Remote Desktop

=====================================================
gem_package
=====================================================
`[edit on GitHub] <https://github.com/chef/chef-web-docs/blob/master/chef_master/source/resource_gem_package.rst>`__

.. warning:: .. tag notes_chef_gem_vs_gem_package

             The **chef_gem** and **gem_package** resources are both used to install Ruby gems. For any machine on which the chef-client is installed, there are two instances of Ruby. One is the standard, system-wide instance of Ruby and the other is a dedicated instance that is available only to the chef-client. Use the **chef_gem** resource to install gems into the instance of Ruby that is dedicated to the chef-client. Use the **gem_package** resource to install all other gems (i.e. install gems system-wide).

             .. end_tag

.. tag resource_package_gem

Use the **gem_package** resource to manage gem packages that are only included in recipes. When a package is installed from a local file, it must be added to the node using the **remote_file** or **cookbook_file** resources.

.. end_tag

.. note:: .. tag notes_resource_gem_package

          The **gem_package** resource must be specified as ``gem_package`` and cannot be shortened to ``package`` in a recipe.

          .. end_tag

Syntax
=====================================================
A **gem_package** resource block manages a package on a node, typically by installing it. The simplest use of the **gem_package** resource is:

.. code-block:: ruby

   gem_package 'package_name'

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

- `ard`
- `machine_name`
- `defaults`
- `pmset`
- `systemsetup`
- `xcode`
- `plist`

Checkout the [Wiki](https://github.com/Microsoft/macos-cookbook/wiki) for details
about the macOS Cookbook resources.
