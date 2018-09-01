# Changelog
All notable changes to this project will be documented in this file.

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
- Fixed a bug in the certificate resource for non-Vagrant use cases.
