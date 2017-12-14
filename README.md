macOS Cookbook
==============

The macOS cookbook is a Chef library cookbook that provides resources for configuring
and provisioning macOS. Additionally, it provides recipes that implement common
use-cases of the macOS cookbook's recources.

|||
|-|-|
| macOS Sierra 10.12 | ![build-status-1012](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2143/badge) |
| macOS High Sierra 10.13 | ![build-status-1013](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2140/badge) |
|||

Requirements
------------

- Only tested on Chef 13
- Surprisingly, this cookbook is only compatible with macOS

Supported OS Versions
---------------------

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

:large_orange_diamond: Requires an `apple_id` data bag item.

**Usage:** `include_recipe macos::xcode`

| Attribute Used                                                | Default value |
|---------------------------------------------------------------|---------------|
| `node['macos']['xcode']['version']`                           |  `'9.1'`      |
| `node['macos']['xcode']['simulator']['major_version']`        | `%w(11 10)`   |

### Apple Configurator 2

Installs Apple Configurator 2 using `mas` and links `cfgutil` to
`/usr/local/bin`.

:large_orange_diamond: Requires an `apple_id` data bag item.

**Usage:** `include_recipe macos::configurator`

**Attributes**: No attributes used in this recipe.

#### Data Bags

Both the `macos::xcode` and `macos::configurator` recipes require a data bag
item named `apple_id` containing valid Apple ID credentials. For example:

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

- [ARD (Apple Remote Desktop)](./documentation/resource_ard.md)
- [Plist](./documentation/resource_plist.md)
- [Xcode](./documentation/resource_xcode.md)
