certificate
=========

Use the **certificate** resource to manage certificates for keychains.
Under the hood, the [**certificate**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/certificate.rb) resource executes the `security`
command in the [**security_cmd**](https://github.com/Microsoft/macos-cookbook/blob/master/libraries/security_cmd.rb) library.

Syntax
------

The full syntax for all of the properties available to the **certificate** resource
is:

```ruby
certificate 'cert name' do
  path                      String # certificate in .p12(PFX) or .cer(SSl certificate file) format. defaults to 'name' if not specified
  password                 String # password for PFX format certificate file
  keychain_path                      String # keychain to install certificate to
  keychain_password                     String # keychain password
  apps                          Array  # list of apps that may access the imported key
  sensitive                     Boolean # run execute resource with sensitive
end
```

Actions
-------

`:install`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the certificate as specified by
the `path` property. This is the only, and default, action.


Examples
--------

**Install PFX format certificate to default keychain**

```ruby
certificate 'cert name' do
  path '/User/edward/Documents/cert.p12'
  password 'teach'
end
```

**Install PFX format certificate to specific keychain**

```ruby
certificate 'cert name' do
  path '/User/edward/Documents/cert.p12'
  password 'teach'
  keychain_path '/User/edward/Library/Keychains/florida.keychain'
  keychain_password 'test'
end
```

**Install SSL format certificate to default keychain**

```ruby
certificate 'cert name' do
  path '/User/edward/Documents/cert.p12'
end
```

**Install SSL format certificate to specific keychain**

```ruby
certificate 'cert name' do
  path '/User/edward/Documents/cert.p12'
  keychain_path '/User/edward/Library/Keychains/florida.keychain'
  keychain_password 'test'
end
```

**Install PFX format certificate to default keychain, accessible by certain app**
```ruby
certificate 'cert name' do
  path '/User/edward/Documents/cert.p12'
  password 'teach'
  apps ['/Applications/Maps.app', '/Applications/Time Machine.app']
end
```
