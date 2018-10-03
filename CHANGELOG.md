# Changelog
All notable changes to this project will be documented in this file.

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
