machine_name
============

Use the **machine_name** resource to manage a machine's name. In theory, the
`machine_name` resource should yield the same results that setting the
**Computer Name** field in System Preferences would.

As defined by the `scutil` manual, an individual macOS system has three different
types of names managed by `scutil`: `ComputerName`, `LocalHostName`, and `HostName`.

The fourth and lesser-known name, the **NetBIOS** name, will be set to an appropriately
formatted version of `HostName` by default unless otherwise set explicitly.

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
- `NetBIOS` name to **JOHNNYS-MACBOOK**.

The full syntax for all of the properties that are available to the **machine_name**
resource is:

```ruby
machine_name 'description' do
  computer_name               String # defaults to 'hostname' if not specified
  local_hostname              String # defaults to 'hostname' if not specified
  hostname                    String # defaults to the 'name' property if not specified
  netbios_name                String # defaults to 'hostname' if not specified
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

`netbios_name`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby type:** `String`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;The 16-byte address used to identify a NetBIOS
resource on the network. In the context of macOS, setting this can be helpful when
you need to identify a machine with certain network scanning tools such as `nmap`
or [Angry IP Scanner](http://angryip.org/).

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

**Note:** This would automatically set the NetBIOS name to JOHNNYS-MACPRO.
