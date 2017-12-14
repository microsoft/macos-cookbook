macOS Cookbook
==============

![build-status](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2140/badge)

The macOS cookbook is a Chef library cookbook that provides resources for configuring
and provisioning macOS. Additionally, it provides recipes that implement common
use-cases of the macOS cookbook's recources.

Requirements
------------

- Chef 13+
- macOS

Attributes
----------

### Admin User and Password

```ruby
node['macos']['admin_user'] = 'vagrant'
node['macos']['admin_password'] = 'vagrant'
```

Each of these attributes defaults to vagrant since our resources are developed
with the Vagrant paradigm. In other words, the use and password declared here
should be an admin user.

### Xcode

```ruby
node['macos']['xcode']['version'] = '9.2'
```

Recipes
-------

- `disable_software_updates`
- `keep_awake`
- `mono`
- `xcode`
- `configurator`

Resources
---------

- `ard`
- `machine_name`
- `defaults`
- `pmset`
- `systemsetup`
- `xcode`
- `plist`

Checkout the [Wiki](https://github.com/Microsoft/macos-cookbook/wiki) for details
about the macOS Cookbook resources.
