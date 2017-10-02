# macOS Cookbook

This cookbook provides:
- Resources for configuring and provisioning macOS.
- Simple recipes for common uses of said recipes

### Platforms

- macOS

### Chef

- Chef 13+

### Attributes

```ruby
node['macos']['admin_user'] = 'vagrant'
node['macos']['admin_password'] = 'vagrant'
```

Each of these attributes defaults to vagrant since our resources are developed
with the Vagrant paradigm. In other words, the use and password declared here
should be an admin user.

### Resources

- `ard`
- `name`
- `defaults`
- `pmset`
- `systemsetup`
- `xcode`

### Recipes

- `disable_software_updates`
- `keep_awake`
- `mono`
- `configurator`

