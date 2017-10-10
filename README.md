# macOS Cookbook

This cookbook provides:
- Resources for configuring and provisioning macOS.
- Recipes that implement common use-cases of the macOS cookbook's recources.

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

_TODO_

---

## Resources

- `ard`
- `name`
- `defaults`
- `pmset`
- `systemsetup`
- `xcode`

Checkout the [Wiki](https://github.com/Microsoft/macos-cookbook/wiki) for details about the macOS Cookbook resources.

---

## Recipes

- `disable_software_updates`
- `keep_awake`
- `mono`
- `configurator`


