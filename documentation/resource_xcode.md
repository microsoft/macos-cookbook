xcode
=====

Use the **xcode** resource to manage a single installation of Apple's Xcode IDE.
The [**xcode**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/xcode.rb) resource manages the state of a single Xcode installation
and any additional iOS simulators that are declared using the `ios_simulators`
property. The latest version of iOS simulators are always installed with Xcode.
This resource supports beta and GM seeds from Apple if currently available via
your developer credentials. Be sure to only provide the semantic version (e.g.
`10.0` and not `10 beta` or `10 GM seed`) in the version property. Providing a
`path` will move an existing Xcode installation of the requested version to that
path, overwriting an existing bundle if it is not the requested version.


Syntax
------

The simplest use of the **xcode** resource is:

```ruby
xcode '9.4.1'
```

which would install Xcode 9.4.1 with the included iOS simulators.

The full syntax for all of the properties that are available to the **xcode**
resource is:

```ruby
xcode 'description' do
  version                              String # defaults to 'description' if not specified
  path                                 String # defaults to '/Applications/Xcode.app' if not specified
  ios_simulators                       Array # defaults to current iOS simulators if not specified
  download_url                         String # defaults to empty if not specified
  action                               Symbol # defaults to [:install_gem, :install_xcode, :install_simulators] if not specified
end
```

Actions
-------
It is recommended to use the default action of all three actions, since the
`xcode-install` gem is required to use the resource. Only use actions independently
if you're going to manage this dependency on your own.

This resource has the following actions:

`:install_gem`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the `xcode-install` gem dependency,
downloading the required Apple Command Line tools if not already present.

`:install_xcode`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Download and install the specified `version`
of Xcode from Apple, move the specified `path`, and make it the active developer
directory for the node.

`:install_simulators`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Download and install latest major version
of iOS simulators declared in `ios_simulators`.

## Authentication with Apple

In order to install Xcode directly from Apple, you'll need to provide a AppleID for an active developer account. There are two methods to do so:

The `xcode` resource can utilize a `credentials` data bag with an `apple_id` data bag item.

**Example:**

```json
{
  "id": "apple_id",
  "apple_id": "farva@spurbury.gov",
  "password": "0k@yN0cR34m"
}
```

The `xcode` resource can also utilize an AppleID set (preferably at run-time for
security, and unset after use) under the node attributes
`node['macos']['apple_id']['user']` and `node['macos']['apple_id']['password']`.

**Example:**

```ruby
node.normal['macos']['apple_id']['user'] = 'farva@spurbury.gov'
node.normal['macos']['apple_id']['password'] = '0k@yN0cR34m'

xcode '10.1'

ruby_block 'Remove AppleID password attribute' do
  block do
    node.rm('macos', 'apple_id', 'password')
  end
end
```

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

**Install Xcode from a local file**

```ruby
xcode '9.2' do
  ios_simulators %w(11 10)
  download_url 'file:///Users/johnny/Desktop/xcode_install.dmg'
end
```
