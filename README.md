macOS Cookbook
==============

The macOS cookbook is a Chef library cookbook that provides resources for configuring
and provisioning macOS. Additionally, it provides recipes that implement common
use-cases of the macOS cookbook's resources.

- [Chef Requirements](#chef-requirements)
- [Supported OS Versions](#supported-os-versions)
- [Attributes](#attributes)
- [Recipes](#recipes)
- [Data Bags](#data-bags)
- [Resources](#resources)

Chef Requirements
-----------------

Currently, we've only tested the macOS cookbook using **Chef 13**. We do intend to implement
better test coverage in order to support more versions of Chef. Let us know
if you find issues with previous versions and we will do our best to resolve them.

Supported OS Versions
---------------------

| OS X El Capitan 10.11 | macOS Sierra 10.12 | macOS High Sierra 10.13 |
|:---------------------:|:------------------:|:-----------------------:|
| ![build-status-1011](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2302/badge) | ![build-status-1012](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2140/badge) | ![build-status-1013](https://office.visualstudio.com/_apis/public/build/definitions/59d72877-1cea-4eb6-9d06-66716573631a/2143/badge) |

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

**Usage:** `include_recipe 'macos::disable_software_updates'`

No attributes used in this recipe.

### Keep Awake

Prevent macOS from falling asleep, disable the screensaver, reboot upon power failure,
enable wake on LAN, enable remote login (SSH) and adjust several other settings
to always keep macOS on and available.

**Usage:** `include_recipe 'macos::keep_awake'`

| Attributes used                         | Default value           |
|-----------------------------------------|-------------------------|
| `node['macos']['remote_login_enabled']` | `true`                  |
| `node['macos']['disk_sleep_disabled']`  | `false`                 |
| `node['macos']['network_time_server']`  | `'time.windows.com'`    |
| `node['macos']['time_zone']`            | `'America/Los_Angeles'` |

### Mono

Installs [Mono](http://www.mono-project.com/docs/about-mono/). Requires setting
the `package`, `version` and `checksum` attributes in order to override.

**Usage:** `include_recipe 'macos::mono'`

| Attributes used                     | Default value                                                        |
|-------------------------------------|----------------------------------------------------------------------|
| `node['macos']['mono']['package']`  | `'MonoFramework-MDK-4.4.2.11.macos10.xamarin.universal.pkg'`         |
| `node['macos']['mono']['version']`  | `'4.4.2'`                                                            |
| `node['macos']['mono']['checksum']` | `'d8bfbee7ae4d0d1facaf0ddfb70c0de4b1a3d94bb1b4c38e8fa4884539f54e23'` |

### Xcode

Installs Xcode 9.2 and simulators for iOS 10 and iOS 11. See the
[Xcode resource documentation](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_xcode.md) if you need
more flexibility.

:warning: Requires a `credentials` data bag containing an `apple_id` data bag item,
or a user/password pair set under `node['macos']['apple_id']`.

**Usage:** `include_recipe 'macos::xcode'`

| Attributes used                                        | Default value |
|--------------------------------------------------------|---------------|
| `node['macos']['xcode']['version']`                    | `'9.2'`       |
| `node['macos']['xcode']['simulator']['major_version']` | `[11, 10]`    |
| `node['macos']['apple_id']['user']`                    | `nil`         |
| `node['macos']['apple_id']['password']`                | `nil`         |

### Apple Configurator 2

Installs Apple Configurator 2 using `mas` and links `cfgutil` to
`/usr/local/bin`.

:warning: Requires a `credentials` data bag containing an `apple_id` data bag item.

**Usage:** `include_recipe 'macos::configurator'`

**Attributes**: No attributes used in this recipe.

Data Bags
---------

Both the `macos::xcode` and `macos::configurator` recipes require a `credentials`
data bag with an `apple_id` data bag item. The item should contain valid Apple ID
credentials. For example:

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

- [ARD (Apple Remote Desktop)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_ard.md)
- [Certificate (security)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_certificate.md)
- [Machine Name](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_machine_name.md)
- [Plist](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_plist.md)
- [Spotlight (mdutil)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_spotlight.md)
- [Xcode](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_xcode.md)
