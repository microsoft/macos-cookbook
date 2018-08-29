# Changelog
All notable changes to this project will be documented in this file.

## [2.4.1] - 2018-08-29
### Fixed
- Resolves an issue where disconnecting from a VNC session in Apple Remote Desktop would trigger a screen lock. This issue is actual a preference,
which is now managed with a new attribute: `node['macos']['vnc_screen_lock_enabled']`

## [2.4.0] - 2018-08-16
### Added
- Added `CHANGELOG.md`. ([Issue #122](https://github.com/Microsoft/macos-cookbook/issues/122)).

### Removed
- `homebrew` cookbook dependency removed. `homebrew_cask` and `homebrew_tap` is being deprecated by Chef and has not been used by `macos-cookbook` since version `2.0`. ([Issue #123](https://github.com/Microsoft/macos-cookbook/issues/123)).

### Fixed
- Fixed `keychain` resource documentation link.
- Update `metadata_util` library to consider Spotlight server status before manipulating indexing state. ([Issue #45](https://github.com/Microsoft/macos-cookbook/issues/45)).
