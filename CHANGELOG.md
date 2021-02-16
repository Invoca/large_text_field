# CHANGELOG for `large_text_field`

Inspired by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Note: This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2021-02-16
### Fixed
- Fixed migration to work with Rails 6 (by adding [4.2] suffix).
- Set rails version to < 6.1 since that moved some files around and broke requires.

## [1.0.0] - 2020-05-15
### Added
- Added support for rails 5 and 6.
- Added appraisal tests for all supported rails version: 4/5/6

### Removed
- Support for `protected_parameters` has been removed

## [0.3.2] - 2020-05-03
### Changed
- Replaced dependence on hobo_support with invoca_utils
- Make invoca_utils a declared dependency. (It always was, it just wasn't declared)

[1.0.1]: https://github.com/Invoca/large_text_field/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/Invoca/large_text_field/compare/v0.3.2...v1.0.0
[0.3.2]: https://github.com/Invoca/large_text_field/compare/v0.3.1...v0.3.2
