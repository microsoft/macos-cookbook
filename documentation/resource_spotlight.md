spotlight
=========

Use the **spotlight** resource to manage the metadata indexing state for disk volumes.
This will primarily affect the ability to search volume contents with the macOS
Spotlight feature. Under the hood, the [**spotlight**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/spotlight.rb) resource executes the `mdutil`
command in the `metadata_util` library.

Syntax
------

The most basic usage of the **spotlight** resource declares a disk volume as
the name property to **enable** metadata indexing:

```ruby
spotlight '/'
```

The full syntax for all of the properties available to the **spotlight** resource
is:

```ruby
spotlight 'volume name' do
  volume                      String # defaults to 'volume name' if not specified
  indexed                     TrueClass, FalseClass # defaults to TrueClass if not specified
  searchable                  TrueClass, FalseClass # defaults to TrueClass if not specified
end
```

Actions
-------

This resource has the following actions:

`:set`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Set the metadata indexing state declared by
the `indexed` property. This is the only, and default, action.

Properties
----------

`volume`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby Type:** `String`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The name of the disk volume to manage.

`indexed`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby type:** `TrueClass, FalseClass`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Whether or not the desired state of the named
disk volume is to be indexed.

`searchable`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby type:** `TrueClass, FalseClass`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Disables Spotlight searching if the index has
already been created for the volume. Only applicable if the `indexed` property is
set to `false`.

Examples
----------

**Enable indexing on the boot volume**

```ruby
spotlight '/'
```

**Disable indexing on 'test_disk1'**

```ruby
spotlight 'test_disk1' do #
  indexed false
end
```

**Enable indexing on a different volume**

```ruby
spotlight 'enable indexing on TDD2' do
  volume 'TDD2'
  indexed true
end
```

**Disable indexing and prevent searching**

```ruby
spotlight 'disable indexing and prevent searching index on TDD-ROM' do
  volume 'TDD-ROM'
  indexed false
  searchable false
end
```
