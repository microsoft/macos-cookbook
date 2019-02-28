# macOS Cookbook

[![Build Status](https://dev.azure.com/office/OE/_apis/build/status/Microsoft.macos-cookbook?branchName=master)](https://dev.azure.com/office/OE/_build/latest?definitionId=5072&branchName=master)

Chef resources and recipes for managing and provisioning macOS.

- [Chef Requirements](#chef-requirements)
- [Supported OS Versions](#supported-os-versions)
- [Attributes](#attributes)
- [Recipes](#recipes)
- [Data Bags](#data-bags)
- [Resources](#resources)

## Supported Chef Versions

- Chef 14

## Supported OS Versions

- macOS Sierra 10.12
- macOS High Sierra 10.13
- macOS Mojave 10.14

## Attributes

### Admin User and Password

```ruby
node['macos']['admin_user'] = 'vagrant'
node['macos']['admin_password'] = 'vagrant'
```

Each of these attributes defaults to vagrant since our resources are developed
with the Vagrant paradigm. In other words, the user and password declared here
should be an admin user with passwordless super-user rights.

## Recipes

### Keep Awake

Prevent macOS from falling asleep, disable the screensaver, reboot upon power failure,
enable wake on LAN, enable remote login (SSH) and adjust several other settings
to always keep macOS on and available.

**Usage:** `include_recipe 'macos::keep_awake'`

| Attributes used                         | Default value           |
|-----------------------------------------|-------------------------|
| `node['macos']['remote_login_enabled']` | `true`                  |
| `node['macos']['network_time_server']`  | `'time.windows.com'`    |
| `node['macos']['time_zone']`            | `'America/Los_Angeles'` |

## Resources

- [ARD (Apple Remote Desktop)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_ard.md)
- [Automatic Software Updates](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_automatic_software_updates.md)
- [Certificate (security)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_certificate.md)
- [Xcode Command Line Tools](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_command_line_tools.md)
- [Keychain (security)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_keychain.md)
- [Machine Name](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_machine_name.md)
- [macOS User (sysadminctl)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_macos_user.md)
- [Plist](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_plist.md)
- [Spotlight (mdutil)](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_spotlight.md)
- [Xcode](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_xcode.md)
