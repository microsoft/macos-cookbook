# macOS Cookbook

[![Build Status](https://dev.azure.com/office/OE/_apis/build/status/Microsoft.macos-cookbook?branchName=master)](https://dev.azure.com/office/OE/_build/latest?definitionId=5072&branchName=master)

Chef resources and recipes for managing and provisioning macOS.

- [Chef Requirements](#officially-supported-chef-versions)
- [macOS Requirements](#officially-supported-os-versions)
- [Included Resources](#resources)

## Officially Supported Chef Versions

- Chef 16
- Chef 17

## Officially Supported OS Versions

- macOS 10.14 Mojave
- macOS 10.15 Catalina
- macOS 11 Big Sur
- macos 12 Monterey

## Resources
**The plist resource is deprecated and will be removed in the next major release of macos-cookbook. Please use the plist resource included with Chef Client >=16.**

- ~~[`plist`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_plist.md)~~
- [`automatic_software_updates`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_automatic_software_updates.md)
- [`certificate`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_certificate.md)
- [`command_line_tools`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_command_line_tools.md)
- [`keychain`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_keychain.md)
- [`macos_user`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_macos_user.md)
- [`remote_management`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_remote_management.md)
- [`spotlight`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_spotlight.md)
- [`xcode`](https://github.com/Microsoft/macos-cookbook/blob/master/documentation/resource_xcode.md)
