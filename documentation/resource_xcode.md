xcode
=====

Use the **xcode** resource to manage a single installation of Apple's Xcode IDE.
An **xcode** resource instance represents the state of a single Xcode installation
and any simulators that are declared using the `ios_simulators` property. The latest
version of iOS simulators are always installed with Xcode. This resource supports
beta and GM seeds from Apple if currently available via your developer credentials.
Be sure to only provide the semantic version (e.g. `9.4` and not `9.4 beta` or
`10 GM seed`) in the version property.

Syntax
------

The simplest use of an **xcode** resource is:

```ruby
xcode '9.3'
```

which would install Xcode 9.3 with the default simulators.

The full syntax for all of the properties that are available to the **xcode**
resource is:

```ruby
xcode 'description' do
  version                              String # defaults to 'description' if not specified
  path                                 String # defaults to '/Applications/Xcode.app' if not specified
  ios_simulators                       Array # defaults to [10, 11] if not specified
  action                               Symbol # defaults to [:install_xcode, :install_simulators] if not specified
end
```

Actions
-------

This resource has the following actions:

`:install_xcode`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Set `entry` to `value` in `path`

`:install_simulators`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Along with a `version` of Xcode,
install the declared array of the major versions of `ios_simulators`.

Examples
--------

**Install different versions of Xcode based on platform version node attributes**

```ruby
if node['platform_version'].match?(/10\.13/) || node['platform_version'].match?(/10\.12/)
  execute 'Disable Gatekeeper' do
    command 'spctl --master-disable'
  end

  xcode '9.2' do
    ios_simulators %w(11 10)
  end

elsif node['platform_version'].match?(/10\.11/)

  xcode '8.2.1' do
    ios_simulators %w(10 9)
  end
end
```
