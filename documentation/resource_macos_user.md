# macos_user

Use the **macos_user** resource to manage user creation.
Under the hood, the [**macos_user**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/macos_user.rb) resource executes the `sysadminctl`
command.

## Syntax

The full syntax for all of the properties available to the **macos_user** resource
is:

```ruby
macos_user 'user and action description' do
  username             String          # username for user
  password             String          # password for user, defaults to "password" if not specified
  autologin            TrueClass       # user autologin
  admin                TrueClass       # admin status of user
  hidden               TrueClass       # hidden status of user
  fullname             String          # full name of user
  groups               Array, String   # list of groups the user is in
  secure_token         TrueClass       # secure token status of user
  existing_token_auth  Hash            # the username and password of an existing secure token user
end
```

Whenever modifying or creating a secure token user, the `existing_token_auth` property must be provided a Hash in the format of: `{ username: 'username', password: 'password' }`. This should not be the user being modified or created, but an existing user on the system who has a secure token, or the owner account of the system.

The following example is equivalent to issuing `"sysadminctl -addUser jlevinson -password serenity -admin"`

```ruby
macos_user 'create admin user' do
  username 'jlevinson'
  password 'serenity'
  admin     true
end
```

## Actions

`:create`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Create a user specified by
`macos_user` properties. If the user already exists, the secure token status will be updated to match.

`:delete`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Delete a user specified by
the `macos_user` username property.

## Examples

**Create a user with admin privileges**

```ruby
macos_user 'create admin user' do
  username 'mscott'
  password '1234'
  autologin true
  admin     true
end
```

**Create a user that is part of several groups**

```ruby
macos_user 'create user' do
  username 'pbeesly'
  password 'cecelia'
  groups   ['reception', 'sales', 'coalition']
end
```

**Create a user that has a fullname**

```ruby
macos_user 'create user' do
  username 'omartinez'
  fullname 'Oscar Martinez'
  password 'reason'
  groups   ['accounting']
end
```

**Create a user that has a secure token**

```ruby
macos_user 'create user' do
  username 'stanley'
  fullname 'Stanley Hudson'
  password 'florida'
  groups   ['sales']
  secure_token true
  existing_token_auth { username: 'robert', password: 'lizard' }
end
```
