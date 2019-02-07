macos_automatic_software_updates
=====

# Description


Syntax
------

The simplest use of the **macos_software_updates** resource is:

```ruby
macos_automatic_software_updates "enables automatic check and download" do
  check true
  download true
  os true
  appstore true
  critical true
end
```
