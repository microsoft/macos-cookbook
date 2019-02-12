automatic_software_updates
=====

# Description


Syntax
------

The simplest use of the **automatic_software_updates** resource is:

```ruby
automatic_software_updates "enables automatic check and download" do
  check true
  download true
  os true
  app_store true
  critical true
end
```
