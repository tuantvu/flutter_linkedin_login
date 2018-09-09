# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v2.0.0 - 2018-09-09
### Added
- loginBasicWithProfile()

### Removed
- static getters for login, profile, and clearSession

## v1.1.0 - 2018-09-09
### Added
- emailAddress, formattedName, and location to LinkedInProfile
- toJson() for LinkedInProfile
- methods loginBasic(), logout(), and getProfile() in preparation to remove getters

## v1.0.0 - 2018-07-22
### Added
- Support for iOS

### Changed
- Android check session valid before getting profile

## v0.1.1 - 2018-07-22
### Changed
- Android MainActivity must override onActivityResult

## v0.0.1 - 2018-07-04
### Added
- Support for Android