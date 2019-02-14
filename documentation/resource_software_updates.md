automatic_software_updates
=====

# Description


Syntax
------

The simplest use of the **automatic_software_updates** resource is:

```ruby
automatic_software_updates "enables automatic check, download, and install of software updates" do
  check true
  download true
  install_os true
  install_app_store true
  install_critical true
end
```

## Actions

The ``automatic_software_updates`` resource has the following actions:

``:set``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default. Set `plist` attribute to true.
