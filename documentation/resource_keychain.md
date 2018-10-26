keychain
=========

Use the **keychain** resource to manage keychains.
Under the hood, the [**keychain**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/keychain.rb) resource executes the `security`
command in the `security_cmd` library.

Syntax
------

The full syntax for all of the properties available to the **keychain** resource
is:

```ruby
keychain 'keychain name' do
  keychain                      String # path to selected keychain
  kc_passwd                     String # password for selected keychain
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
the `keychain` property. If no keychain is specified, the default keychain
will be locked instead.

`:unlock`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Using the `kc_passwd` property, unlock a
keychain as specified by the `keychain` property. If no keychain is specified,
the default keychain will be unlocked instead.



Examples
--------

**Create a keychain**

```ruby
keychain 'test' do
  keychain '/User/edward/Library/Keychains/test.keychain'
  kc_passwd 'test'
  action :create
end
```

**Delete a keychain**

```ruby
keychain 'test' do
  keychain '/User/edward/Library/Keychains/test.keychain'
  action :delete
end
```

**Create a login keychain**

```ruby
keychain 'login' do
  keychain '/User/edward/Library/Keychains/login.keychain'
  kc_passwd 'login_password'
  action :create
end
```

**Lock a keychain**

```ruby
keychain 'test' do
  keychain '/User/edward/Library/Keychains/test.keychain'
  action :lock
end
```

**Unlock a keychain**

```ruby
keychain 'test' do
  keychain '/User/edward/Library/Keychains/test.keychain'
  kc_passwd 'test'
  action :unlock
end
```
