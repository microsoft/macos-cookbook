# macOS Cookbook

This cookbook provides:
- Resources for configuring and provisioning macOS.
- Recipes for common uses of the macos-cookbook recources.

## Platforms

- macOS

## Chef

- Chef 13+

## Attributes

### Admin User and Password

```ruby
node['macos']['admin_user'] = 'vagrant'
node['macos']['admin_password'] = 'vagrant'
```

Each of these attributes defaults to vagrant since our resources are developed
with the Vagrant paradigm. In other words, the use and password declared here
should be an admin user.

### Mono



## Resources

- `ard`
- `name`
- `defaults`
- `pmset`
- `systemsetup`
- `xcode`

### ard

#### Syntax

An *ard* resource block declares an `ard` command with specific options using Chef actions. For example:

```ruby
ard 'activate and configure ard' do
  action [:activate, :configure]
end
```

### defaults

#### Syntax

A *defaults* resource block declares a defaults domain and desired keys and values that wish to be changed. For example, to stop apps
from relaunching at startup and login:

```ruby
defaults 'com.apple.loginwindow' do
  settings 'LoginwindowLaunchesRelaunchApps' => false,
           'TALLogoutReason' => 'Restart',
           'TALLogoutSavesState' => false
  user node['apex_automation']['test_user']
end
```

## Recipes

- `disable_software_updates`
- `keep_awake`
- `mono`
- `configurator`


