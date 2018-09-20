# Changelog
All notable changes to this project will be documented in this file.

## [2.5.0] - 2018-09-10
### Added

### Fixed

## [2.4.0] - 2018-08-16
### Added
- Added `CHANGELOG.md`, About time right? ([Issue #122](https://github.com/Microsoft/macos-cookbook/issues/122)).

### Removed
- `homebrew` cookbook dependency removed. `homebrew_cask` and `homebrew_tap` is being deprecated by Chef and has not been used by `macos-cookbook` since version `2.0`. ([Issue #123](https://github.com/Microsoft/macos-cookbook/issues/123)).

### Fixed
- Fixed `keychain` resource documentation link.
- Update `metadata_util` library to consider Spotlight server status before manipulating indexing state. ([Issue #45](https://github.com/Microsoft/macos-cookbook/issues/45)).

## [2.3.0] - 2018-06-28
### Added
- Like a trained ninja of the night, the `macos_user` now has a hidden property, making it impossible to detect from the login screen.
- Moved to a new set of internal Vagrant macOS boxes, which have much more minimal initial configuration. This ensures that our resources run from a more out-of-the-box macOS experience.

### Fixed
- Fixed bug where deletion of a user was failing when using the macos_user resource.
- For those of you who like to set their user and password as the same characters, we fixed an issue in the certificate resource for non-Vagrant use cases, you know for normal human beings who like a secure environment.

## [2.2.0] - 2018-05-29
### Added
- FoodCritics can be pretty harsh in their critiquing of food. They also have some pretty in depth rules we need to comply with, so we updated machine_name to comply with the new FoodCritic rule FC115.
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
