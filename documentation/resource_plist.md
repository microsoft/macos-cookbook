plist
=====

Use the **plist** resource to manage property list files (plists) and their content.
A **plist** resource instance represents the state of a single key-value pair in
the delared plist `path`. Since each plist resource instance represents only one
setting, you may end up with several plist resource calls in a given recipe. Although
this may seem like overkill, it allows us to have a fully idempotent resource with
fine granularity.

During the `chef-client` run, the client knows to check the state of the plist
before changing any values. It also makes sure that the plist is in binary format
so that the settings can be interpreted correctly by the operating system.

Prior knowledge of using commandline utilities such as `/usr/bin/defaults`
and `/usr/libexec/PlistBuddy` will be useful when implementing the
**plist** resource.

[Learn more about property lists.](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/PropertyLists/QuickStartPlist/QuickStartPlist.html#//apple_ref/doc/uid/10000048i-CH4-SW5)

Syntax
------

The full syntax for all of the properties that are available to the **plist**
resource is:

```ruby
plist 'description' do
  path                                 String # defaults to 'description' if not specified
  entry                                String
  value                                TrueClass, FalseClass, String, Integer, Float 
  action                               Symbol # defaults to :set if not specified
end
```

Actions
-------

This resource has the following actions:

`:set`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Set `entry` to `value` in `path`

Examples
--------

Enabling the setting to show both visible and invisible files.

```ruby
plist 'show hidden files' do
  path '/Users/vagrant/Library/Preferences/com.apple.finder.plist'
  entry 'AppleShowAllFiles'
  value true
end
```

where

`path` is the absolute path to the `com.apple.finder.plist` plist file

`entry` is the representing the plist entry `'AppleShowAllFiles'`

`value` is the entry's value to boolean type: `true`
