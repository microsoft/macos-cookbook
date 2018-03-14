keychain
=========

Use the **keychain** resource to manage keychains.
Under the hood, a **keychain** resource executes the `security`
command in the `security_cmd` library.

[Learn more about keychains](https://support.apple.com/kb/PH20093?locale=en_US).

[Learn more about `security`](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/security.1.html).

Syntax
------

The full syntax for all of the properties available to the **keychain** resource
is:

```ruby
keychain 'keychain name' do
  keychain                      String # 
  kc_passwd                     String # 
  default                      
  login
end
```

Actions
-------

`:create`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create a keychain as specified by
the `keychain` property. This is the default action.

`:delete`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete a keychain as specified by
the `keychain` property. 

`:lock`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lock a keychain as specified by
the `keychain` property. This can also be used to lock all keychains or 
just the default keychain.

`:unlock`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Unlock a keychain as specified by
the `keychain` property. 



Examples
--------

**Create a default login keychain**

```ruby
keychain 'keychain name' do
  keychain '/User/edward/Library/Keychains/test.keychain'
end
```