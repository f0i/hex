# Changelog

## 1.0.2 - 2025-09-23

### Update Dependencies

- update to core@1.0.0

### Add format options

- Add formatting option for URL encoded bytes (`URL`)

## 1.0.1 - 2025-08-02

### Changed
- Improved error messages for hex parsing functions.

### Added
- Added tests for helper functions.

### Documentation
- Updated README with usage example and link to byte-utils.
- Fixed example output in README.

## 1.0.0 - 2025-08-02

### Features
- Core hex conversion functions (`toText`, `toArray`, `toArrayUnsafe`).
- Functions for 2D byte array conversion (`toText2D`, `toText2DFormat`).
- Flexible formatting options (`Format`, `Format2D`, `COMPACT`, `VERBOSE`, `MATRIX_2D`, etc.) for hex representation.
- Support for upper case hex formatting.
- Comprehensive test suite.

### Documentation
- Added formatting documentation.
- Created and updated README with project overview.

### Build/CI
- Integrated mops toolchain and dfx into GitHub workflow for continuous integration.
