# Changelog

=======

## [6.0.7] - 2025-04-18

### Added

- Added key `LastSeenIntelligenceProductVersion` to `macos_user` resource to allow for dismissing more Welcome screens in macOS 15.4.1.

## [6.0.0] - 2024-04-04

### Removed

- Removed the `plist` resource

### Fixed

- Fixed issues with ARD not working on macOS Monterey.
- Fixed an xcode-install gem issue.

### Added

- Added additional functionality to the [remote_management](resources/remote_management.rb) resource.
  - You can now specify the users to whose privileges will be configured.
  - You can now specify the privileges to bestow upon the given users.
  - You can now set the computer info fields; this is helpful for stratifying computers within ARD.

- Added support for `macos_user` to create an account with no password.
- Added support for `command_line_tools` to install beta versions.

## [5.1.0] - 2023-06-27

### Fixed

- Fixed issues with ARD not working on macOS Monterey.
- Ensured that CLT demand file always exists before we query the SWU catalog.

## [5.0.6] - 2023-06-23

### Fixed

- Fixed permissions issue with the `macos::command_line_tools` resource.

## [5.0.5] - 2023-06-20

### Fixed

- Updated `command_line_tools` so that machines are able to install previously installed command line tools if they were wiped from a major macOS upgrade.

## [5.0.4] - 2023-01-31

### Added

- Added key `LastPrivacyBundleVersion` to `macos_user` resource to allow for dimissing more Welcome screens in macOS 12.6.3

## [5.0.3] - 2022-11-16

### Fixed

- Xcode resource verifies that a `xcodebuild` command can be ran when checking to see if Xcode is installed, in addition to verifying that Xcode.app exists.

## [5.0.2] - 2022-09-08

### Added

- Xcode resource logs the Xcode version to install computed from the provided version.
- Xcode library supports calling the `version` property more than once by not changing the stored data type.

## [5.0.1] - 2022-05-25

### Fixed

- Updated Setup Assistant keys for the `macos_user` resource to properly enable autologin after updating to 11.6.6
- Updated required macOS minimums for the `xcode` resource to evaluate compatibility for the most recent Xcodes.

## [5.0.0] - 2022-03-31

### Fixed

- Extracted authentication with Apple via `xcode` resource away `xcode` object instantiation, resolving [Bug #234](https://github.com/microsoft/macos-cookbook/issues/234).
- Enabled `macos_user` resource to parse `sysadminctl` stderr, resolving [Bug 197](https://github.com/microsoft/macos-cookbook/issues/197).
- Reversed order of arguments for certificate installation, resolving [Bug 244](https://github.com/microsoft/macos-cookbook/issues/244).
- Fixed `macos_user` resource `autologin` functionality to dismiss Welcome "buddy" screens after updating to 11.6.5 via `softwareupdate`.

### Added

- Added `apple_id` property to `xcode` resource to remove dependency on attributes or data bags for authentication.
- New `certificate` resource property: `keychain_password` which allows specification of the keychain password.
- New `keychain` resource property: `user` which allows specification of an executing user.
- New test suites and recipe change to account for `.cer` files.
- Check for certificate existence within the keychain before installing a new one to ensure idempotency.
- Support for Mac Studio in `FormFactor` class.
- Secure token support for `macos_user` resource via new properties `secure_token` and `existing_token_auth`.
- New unit and integration tests for `macos_user` resource.
- Updated our README to include Monterey support.
- Added the documentation directory to chefignore as we don't need to upload all our docs to Chef Infra Servers.

### Changed

- Changed `certificate` property names to be more clear within resource scope and consistent with `keychain` resource:
  - `certfile` is now `path`
  - `cert_passwd` is now `password`
  - `keychain` is now `keychain_path`
- Changed `keychain` property names to be more clear within resource scope and consistent with `certificate` resource:
  - `kc_file` is now `path`
  - `kc_passwd` is now `password`
- Made certificate password properties sensitive.
- Deprecated `plist` resource in favor of the `plist` resource included with Chef Client >=16.
- Unified `macos_user` test suites.
- Updated `macos_user` resource to use not utilize default attributes for authorization.
- Updated all deprecated tool names, shell outputs, and URLs in `TESTING.md`

### Removed

- Removed the ability to authenticate with Apple for `xcode` downloads via node attributes or data bags.
- Removed dependency on using the `default['macos']['admin_password']` attribute for setting the keychain password when using the certificate resource.
- Removed last default cookbook attributes:
  - `node['macos']['admin_user']`
  - `node['macos']['admin_password']`
  - `node['macos']['apple_id']`

## [4.2.3] - 2022-02-03

### Fixed

- Enforce sensitivity for the `macos_user` resource `password` property as a security measure. This prevents downstream users from needing to declare `sensitive true` on the resource call.

## [4.2.2] - 2021-10-18

### Fixed

- `defaults` data conversion now handles spaces in strings, arrays, and dictionaries.
- The original data conversion code converted Ruby data types naively into strings. Unfortunately, this format isn't in the format that defaults expects.
- This change modifies the data conversion process to correctly output the expected data in a format acceptable to defaults, while also adding in additional tests to verify the output of the conversion process.

## [4.2.1] - 2021-09-14

### Fixed

- Updated `xcode` library download catalog matching to Apple's new 'Release Candidate' naming scheme.
- Updated `xcode` resource behavior to delete any existing Xcode bundles if they exist at the requested path.

## [4.2.0] - 2021-06-09

### Added

- Added basic support and testing for macOS Monterey.

### Removed

- Removed testing and official support for macOS High Sierra.
- Removed testing and official support for Chef 16.

### Fixed

- The `command_line_tools` OS version parsing regex has been fixed for the new macOS versioning scheme.

## [4.1.0] - 2021-06-07

### Added

- Added support for [Chef 17](https://docs.chef.io/release_notes_client/#whats-new-in-170). macOS High Sierra test suites will still be utilizing Chef 16.
- Added `unified_mode true` to all resources. See [Unified Mode in Custom Resources][unified-mode-in-custom-resources] for more information.

## [4.0.0] - 2021-02-25

### Removed

- Deleted last deprecated recipe `macos::keep_awake` and associated tests.

## [3.4.3] - 2021-02-25

### Fixed

- Updated `XCVersion` library `available_versions` output to _actually_ not include "(installed)" status, as well as chomp newline characters.

- Updated unit tests to match new `XCVersion.available_versions` output.

## [3.4.2] - 2021-02-10

### Fixed

- Updated `xcversion` library `list` output to not include "(installed)" status, since this is determined separately in the `xcode` resource. The additional string content was breaking parsing that prevents installation on non-complete Xcode bundles such as `12 for macOS Universal Apps`.

- Fixes for Cookstyle version: 7.7.2

### Removed

- Removed ChefSpec testing on deprecated Fauxhai platforms

## [3.4.1] - 2020-09-25

### Added

- Added `plist` method to `SystemPath` library to match the methods in `UserPath`.

## [3.4.0] - 2020-08-05

### Added

- Support and testing for Big Sur. Due to a bug in the `kickstart` script in Big Sur, the `remote_management`
  resource is not functional on any system that reports `11.0` instead of `10.16`, which is the case
  on 20A5323l (beta 3) or later. This will be resolved at a later date.

- Deprecation notice for `macos::keep_awake`.

### Fixed

- The `xcode` resource now installs the latest available beta revision or GM seed of Xcode if there
  is not an official release of the requested version. Note that installing the early "Xcode 12 for macOS
  Universal Apps" betas is not supported since Apple has already unified these into the core Xcode
  bundles as of 12A8169g (beta 3).

- The `macos_user` resource now prevents the screen from re-locking at boot when auto-login is enabled.

- The `command_line_tools` OS version parsing regex has been fixed for macOS 11.0

- The `automatic_software_updates` resource tests have been fixed for macOS 11.0

## [3.3.0] - 2020-06-18

### Added

- Support for Chef 16

### Fixed

- Fixed an issue where the beta version of Xcode would be installed over the GM
  version if both were still available from Apple.
- Updated the Xcode OS platform compatibility logic. Thanks @nickdowell!
- Numerous cookstyle fixes.

### Removed

- Rspec dependency on `chef-sugar`

## [3.2.1] - 2020-03-03

### Fixed

- Fixed an issue with the `system` library where a system without hypervisor
  software installed could be mistakenly identified as a VM and not have certain
  platform-specific power preferences set.

## [3.2.0] - 2019-12-09

### Added

- Added an `:upgrade` action to the `command_line_tools` resource
- Added support for dictionaries to the `plist` resource

## [3.1.0] - 2019-10-09

### Added

- Added support for macOS Catalina
- Added support for Chef 15
- Added `UserPath` and `SystemPath` libraries to simplify calls to macOS filepaths

### Fixed

- Fixed an issue parsing new `softwareupdate` output on macOS Catalina
- Fixed a dependency issue with `xcode-install` on Chef 15
- Fixed and updated the `xcode` resource platform compatibilty check (thanks to xcodereleases.com for tracking this)

### Removed

- Removed testing on macOS Sierra
- Removed testing on Chef 14
- Removed dependency on `chef-sugar`

## [3.0.9] - 2019-09-11

### Fixed

- Fixed an issue where the Xcode resource cannot find the Xcode 11 GM bundle path to move it to the declared path in the resource. It removes a logic tree in favor of matching the behavior of the xcode-install gem: <https://github.com/xcpretty/xcode-install/blob/74b89805462d6795d964935239f78e6d2790a52d/lib/xcode/install.rb#L282>, which is to replace spaces in the version listed by Apple with a period.

- Fixed an issue where installing the xcode-install gem fails on Chef 15

- Fixed an issue where the Xcode resource attempted to write to the read-only portion of the Catalina filesystem.

## [3.0.8] - 2019-07-31

### Fixed

- Fixed an issue where Xcode versions containing whitespace were not properly quoted in command execution. Regression from version 2.10 release.

## [3.0.1] - 2019-03-15

Thanks to @jkronborg for these two fixes!

### Fixed

- Fixed a guard in `keep_awake` for use on portables.
- Fixed incorrect attribute key in the Xcode resource documentation, and added a security suggestion.

## [3.0.0] - 2019-02-28

### Added

- Added `automatic_software_updates` resource to enable or disable the automatic checking, downloading, and installing of software updates.
- Added `azure-pipelines.yml` to allow for managing builds as code.
- Added some resource unit tests for `spotlight` to complement the existing `metadata_util` tests.

### Changed

- Changed the `ard` resource to `remote_management` and updates applicable tests and documentation. The new `remote_management` resource greatly simplifies syntax and reduces the needed macOS domain knowledge around `kickstart` options. However, it has less functionality than `ard` and is a significant breaking change.

### Fixed

- Fixed .mailmap file to accurately track contributor emails.
- Fixed guard in the `keychain` resource for the `:create` action.

### Removed

- Adiós, Captain! We no longer support OS X El Capitan or Chef 13.
- Removed `machine_name` resource along with respective tests and documentation in favor of the `hostname` resource in Chef 14.
- Removed `xcode` recipe along with respective tests, documentation and node attributes in favor of `command_line_tools` resource which was released in 2.10.0.
- Removed `disable_software_updates` recipe along with respective tests and documentation in favor of `automatic_software_updates` resource.
- Removed `default` recipe - it was empty anyway.

## [2.10.1] - 2019-01-29

### Fixed

- Fixed issue in which setting certain `machine_name` resource properties (`hostname`, `local_hostname`, `dns_domain`) from a previously unset state, would fail to compile. ([Issue #181](https://github.com/Microsoft/macos-cookbook/issues/181)).

## [2.10.0] - 2019-01-16

### Added

- Added `command_line_tools` resource to manage Xcode Command Line Tools installation for macOS.
- New Xcode property `download_url`. ([Issue #174](https://github.com/Microsoft/macos-cookbook/issues/174)).

### Changed

- Bump Xcode to 10.1 in default attributes file.

### Fixed

- Resolved an issue where a unit test was not passing due to a typo.

## [2.9.0] - 2018-12-06

### Added

- Added templates for bug reports, feature requests, and pull requests to adhere with Github's [recommended community standards](https://opensource.guide).
- Added support for owner/group in the plist resource. Allows for plist files to be created under a specific owner. Defaults to root/wheel for compatibility with earlier versions of the cookbook. ([Issue #51](https://github.com/Microsoft/macos-cookbook/issues/51))
- Added support for setting the mode property when creating a plist using the `plist` resource. This allows control over setting the file permissions. ([Issue #51](https://github.com/Microsoft/macos-cookbook/issues/51))

## [2.8.1] - 2018-11-29

### Fixed

- Fixed an issue where the path for the `xcversion` utility was hard-coded when installed as a Chef gem, which caused failures when converging with ChefDK or Workstation.

## [2.8.0] - 2018-11-14

### Added

- Sugar helps the code go down! We now depend on [Chef Sugar](https://supermarket.chef.io/tools/chef-sugar) for `mac_os_x?`, `virtual?`, `mac_os_x_before_or_at_maverick?`, etc.

### Fixed

- Fixed an issue where Software Update Catalog provides an incomplete list causing some converge failures. We now check for `platform_specific.empty?` and produce appropriate errors.

## [2.7.0] - 2018-10-26

### Added

- Multi-converge testing added for all kitchen suites, idempotency enforced for select resources. Idempotency issues identified and resolved with the `keep_awake` recipe, the `spotlight` resource, and the `ard` resource
  as a result. More enforcing by the idempotence police to come in future releases.

### Removed

- Removal of dead links in documentation for resources to allow for more up to date and clear documentation. ([Issue #129](https://github.com/Microsoft/macos-cookbook/issues/129)).

### Fixed

- Resolved an issue with the `ard` resource where a Chef run sometimes fails due to an intermittent `kickstart` failure. Guards added to the default resource actions to prevent this issue. ([Issue #70](https://github.com/Microsoft/macos-cookbook/issues/70)).
- Resolved an issue with the `spotlight` resource where `mdutil` output was improperly parsed and
  `mdutil` commands were re-ran when not needed.

## [2.6.1] - 2018-10-04

### Added

- The desert took its toll, the README now declares support for Mojave!

## [2.6.0] - 2018-10-03

### Added

- Apple has limited some kickstart command functionality in macOS Mojave, preventing screen
  control in some invocations. We verified the `ard` resource's implementation of the `kickstart` script still functions.

- Updated Xcode default version to 10.0.

- The team crossed the great Mojave Desert, collapsed from dehydration, all just to obtain its support. In other words we now support macOS Mojave.

### Fixed

- Prevented the `xcode` resource from leaving available Command Line Tools downloads
  in Software Updates.

### Deprecated

- The `machine_name` resource has been deprecated in favor of the macOS support in the `hostname` resource in Chef 14. It will be removed in the release of v3.0 of the macOS cookbook.

## [2.5.0] - 2018-09-10

### Added

- Added `CHANGELOG.md`, About time right? ([Issue #122](https://github.com/Microsoft/macos-cookbook/issues/122)).
- Added functional `path` property to Xcode resource. ([Issue #116](https://github.com/Microsoft/macos-cookbook/issues/116)).
- Added ChefSpec resource tests for Xcode.

### Fixed

- Separated extra responsibilities of Xcode resource into DeveloperAccount and
  CommandLineTools libraries.

## [2.4.0] - 2018-08-16

### Added

- Added `CHANGELOG.md`. ([Issue #122](https://github.com/Microsoft/macos-cookbook/issues/122)).

### Removed

- `homebrew` cookbook dependency removed. `homebrew_cask` and `homebrew_tap` is being deprecated by Chef and has not been used by `macos-cookbook` since version `2.0`. ([Issue #123](https://github.com/Microsoft/macos-cookbook/issues/123)).

### Fixed

- Fixed `keychain` resource documentation link.
- Update `metadata_util` library to consider Spotlight server status before manipulating indexing state. ([Issue #45](https://github.com/Microsoft/macos-cookbook/issues/45)).

## [2.3.0] - 2018-06-28

### Added

- Like a trained ninja of the night, the `macos_user` now has a `hidden` property, making it impossible to detect from the login screen.
- Moved to a new set of internal Vagrant macOS boxes, which have much more minimal initial configuration. This ensures that our resources run from a more out-of-the-box macOS experience.

### Fixed

- Fixed bug where deletion of a user was failing when using the macos_user resource.
- For those of you who like to set their user and password as the same characters, we fixed an issue in the certificate resource for non-Vagrant use cases, you know for normal human beings who like a secure environment.

## [2.2.0] - 2018-05-29

### Added

- Foodcritics can be pretty harsh in their critiquing of food. They also have some pretty in depth rules we need to comply with, so we updated machine_name to comply with the new FoodCritic rule FC115.
- Added guard config to automatically run relevant unit tests when a file is changed.
- Update to InSpec control filenames to match the standard. This allows for better understanding of the tests.

## [2.1.0] - 2018-05-16

### Added

- Created an autologin functionality on 10.13.4 to allow for machine to automatically login to the machine.

## [2.0.0] - 2018-05-09

### Removed

- Removed the Mono recipe as it is not in the scope of this cookbook.
- Removed Apple Configurator recipe as a bug with the `mas` dependency does not function in High Sierra.

## [1.14.0] - 2018-05-01

### Added

- Updated the `keep_awake` recipe and spec tests to not require node attribute stubbing when wrapped in another cookbook.

## [1.13.0] - 2018-04-25

### Added

- Added a CONTRIBUTING.md to outline the Chef Community Guidelines for code contribution.

### Fixed

- Fixed an issue with ChefSpec when wrapping the `keep_awake` recipe.
- Fixed an idempotence issue with the keychain resource.

## [1.12.0] - 2018-04-16

### Added

- Added new keychain resource
- Introduced three new library classes `Power`, `Environment`, and `ScreenSaver`.
- Updated README.md to reflect single build definition.
- Added feature to make disk sleep default to `Never`.

## [1.11.0] - 2018-04-11

### Added

- Added the ability to install Xcode beta builds to the `xcode` resource.
- Added support for Chef 14.

## [1.10.0] - 2018-03-26

### Added

- Added feature that allows node attributes to be set for Developer Apple ID credentials while downloading Xcode from Apple.
- Added ability to install Command Line tools from the `xcode-install` gem.

### Fixed

- Increased timeout for Xcode download for issue where method `bundle_version_correct` fails and unsuccessfully tries to access node attributes in Xcode library.
- Resolved issue where adding users and groups would fail tests.

## [1.9.0] - 2018-03-21

### Added

- Added support for other hypervisors and keep away logic.
- Implemented `-t` option in `certificate` resource to allow apps to access imported key.
- Add `utf-8` encoding type to `plist` resource to make it more robust.

## [1.8.0] - 2018-03-12

### Added

- Added a `dns_domain` property to `machine_name` resource to support FQDNs.
- Added TESTING.md documentation.
- Changed `binary` property to `encoding` to support xml and binary plist formats.

### Removed

- Removed support for `NetBIOSName` due to macOS bugs.

### Fixed

- Fixed several bugs in `plist` resource.
- Fixed typos in `machine_name` resource documentation.

## [1.7.0] - 2018-03-05

### Added

- Added the `certificate` resource, this resource manages the state of a given certificate for a specified keychain.

## [1.6.0] - 2018-02-20

### Added

- Added whitespace support for property list names and keys.

### Fixed

- Fixed some depreciation bugs in the `macos_user` resource.
- Fixed idempotency bug in `.kitchen.yml`.

## [1.5.0] - 2018-02-12

### Added

- Added new `system_preference` resource.

### Removed

- Removed `systemsetup` resource.
- Removed `.delivery` in favor of `kitchen test` and concurrency testing model.

### Fixed

- Fixed issue where `plist` resources cause incomplete idempotence on second converge by making the `keep_awake` recipe idempotent. ([Issue #15](https://github.com/Microsoft/macos-cookbook/issues/15)).
- Fixed issue where `macos_user` was not allowing users to be added to groups by creating a new `groups` property. ([Issue #40](https://github.com/Microsoft/macos-cookbook/issues/40)).
- Fixed issue where `machine_name` resource does not set `LocalHostName` by making `machine_name` idempotent and having it properly set the `LocalHostName`. ([Issue #20](https://github.com/Microsoft/macos-cookbook/issues/20)).

## [1.3.0] - 2018-02-02

### Added

- Added helper modules for `systemsetup`.
- Added new attributes to adjust the `keep_awake` functions.
- Added better functionality to the `keep_awake` power resources.

### [1.2.0] - 2018-01-28

### Added

- Initial release of the macOS Cookbook.
- Chef support for 10.10 to 10.13.
- Added `xcode` resource.
- Added `keep_awake` recipe.
- Added `spotlight` resource.
- Added `machine_name` resource.
- Added `macos_user` resource.

[unified-mode-in-custom-resources]: https://docs.chef.io/release_notes_client/#unified-mode-in-custom-resources
