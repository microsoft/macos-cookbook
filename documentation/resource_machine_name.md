machine_name
============

Use the [**machine_name**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/machine_name.rb) resource to manage a machine's name. In theory, the
`machine_name` resource should yield the same results that setting the
**Computer Name** field in System Preferences would.

As defined by the `scutil` manual, an individual macOS system has three different
types of names managed by `scutil`: `ComputerName`, `LocalHostName`, and `HostName`.

A `dns_domain` property can be optionally specified. This will be tacked on to the
end of the specified `hostname` property to form a fully-qualified domain name
that the system `HostName` will be set to.

When the state of a `machine_name` resource changes, an `ohai` resource is notified
to reload; this is so that all name changes are reflected and immediately available
via the node's normal attributes. Additionally, regardless of the chosen `ComputerName`,
both `HostName` and `LocalHostName` will be formatted to adhere to [RFC 1034](https://tools.ietf.org/html/rfc1034).

Syntax
------

A **machine_name** resource block manages a machine's name. The simplest use of
the **machine_name** resource is:

```ruby
machine_name "Johnny's MacBookPro"
```

which would set:

- `ComputerName` to **Johnny's MacBookPro**
- `LocalHostName` to **Johnnys-MacBookPro**
- `HostName` to **Johnnys-MacBookPro**

The full syntax for all of the properties that are available to the **machine_name**
resource is:

```ruby
machine_name 'description' do
  computer_name               String # defaults to 'hostname' if not specified
  local_hostname              String # defaults to 'hostname' if not specified
  hostname                    String # defaults to the 'name' property if not specified
  dns_domain                  String
end
```

Properties
----------

`computer_name`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby type:** `String`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The user-friendly name for the system.

`local_hostname`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby type:** `String`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The local (Bonjour) host name.

`hostname`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby Type:** `String`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The name associated with `hostname(1)` and `gethostname(3)`.

`dns_domain`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby type:** `String`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Domain Name System domain name.

Examples
--------

**Set `HostName`, `LocalHostName`, and `ComputerName` to different values**

```ruby
machine_name 'set computer/hostname' do
  hostname 'johnnys-macpro'
  computer_name "Johnny's MacPro"
  local_hostname "Johnnys-MacPro"
  dns_domain 'vagrantup.com'
end
```
