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
  path                       String # path to selected keychain, defaults to 'name' if not specified
  password                     String # password for selected keychain
  sensitive                     Boolean # run execute resource with sensitive
end
```

Actions
-------

`:create`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create a keychain as specified by
the `path` property. This is the default action.

`:delete`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete a keychain as specified by
the `path` property.

`:lock`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lock a keychain as specified by
the `path` property. If no keychain is specified, the default keychain
will be locked instead.

`:unlock`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Using the `password` property, unlock a
keychain as specified by the `path` property. If no keychain is specified,
the default keychain will be unlocked instead.



Examples
--------

**Create a keychain**

```ruby
keychain 'test' do
  path '/User/edward/Library/Keychains/test.keychain'
  password 'test'
  action :create
end
```

**Delete a keychain**

```ruby
keychain 'test' do
  path '/User/edward/Library/Keychains/test.keychain'
  action :delete
end
```

**Create a login keychain**

```ruby
keychain 'login' do
  path '/User/edward/Library/Keychains/login.keychain'
  password 'login_password'
  action :create
end
```

**Lock a keychain**

```ruby
keychain 'test' do
  path '/User/edward/Library/Keychains/test.keychain'
  action :lock
end
```

**Unlock a keychain**

```ruby
keychain 'test' do
  path '/User/edward/Library/Keychains/test.keychain'
  password 'test'
  action :unlock
end
```
