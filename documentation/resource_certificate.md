certificate
=========

Use the **certificate** resource to manage certificates for keychains.
Under the hood, the [**certificate**](https://github.com/Microsoft/macos-cookbook/blob/master/resources/certificate.rb) resource executes the `security`
command in the `security_cmd` library.

Syntax
------

The full syntax for all of the properties available to the **certificate** resource
is:

```ruby
certificate 'cert name' do
  certfile                      String # certificate in .p12(PFX) or .cer(SSl certificate file) format
  cert_passwd                   String # password for PFX format certificate file
  keychain                      String # keychain to install certificate to
  apps                          Array  # list of apps that may access the imported key
end
```

Actions
-------

`:install`

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the certificate as specified by
the `certfile` property. This is the only, and default, action.


Examples
--------

**Install PFX format certificate to default keychain**

```ruby
certificate 'cert name' do
  certfile '/User/edward/Documents/cert.p12'
  cert_passwd 'teach'
end
```

**Install PFX format certificate to specific keychain**

```ruby
certificate 'cert name' do
  certfile '/User/edward/Documents/cert.p12'
  cert_passwd 'teach'
  keychain '/User/edward/Library/Keychains/florida.keychain'
end
```

**Install SSL format certificate to default keychain**

```ruby
certificate 'cert name' do
  certfile '/User/edward/Documents/cert.p12'
end
```

**Install SSL format certificate to specific keychain**

```ruby
certificate 'cert name' do
  certfile '/User/edward/Documents/cert.p12'
  keychain '/User/edward/Library/Keychains/florida.keychain'
end
```

**Install PFX format certificate to default keychain, accessible by certain app**
```ruby
certificate 'cert name' do
  certfile '/User/edward/Documents/cert.p12'
  cert_passwd 'teach'
  apps ['/Applications/Maps.app', '/Applications/Time Machine.app']
end
```
