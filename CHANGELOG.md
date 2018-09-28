# Changelog
All notable changes to this project will be documented in this file.

## [2.6.0] - 2018-09-27
### Added
- Apple increased the security for the kickstart command in macOS Mojave, which we use to configure the remote management settings. Despite Apple's warning of Remote Management not being activated, we have a test that verifies it still activates.
- The team crossed the great Mojave Desert, collapsed from dehydration, all just to obtain its support. In other words we now support macOS Mojave.
- Updated Xcode to support version 10.

## [2.5.0] - 2018-09-10
### Added
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
