# Changelog

## [0.4.0] -- Unreleased

- Add more informative error message when remote jinja template is not found
- Allow commands with braces that are not variables without crashing.

## [0.3.0] -- 2023-11-06

- Revamped the `_md` and `_array` variables to be dicts, with `ext`, `content`, `frontmatter`, and `path` properties.
- Added in ability to specify abstract targets, which don't show up in buildable lists, [issue 19](https://github.com/databio/markmeld/issues/19)
- mm now raises an error if you try to inherit from an non-existing target, [issue 20](https://github.com/databio/markmeld/issues/20)
- Overriding targets is no longer allowed, [issue 22](https://github.com/databio/markmeld/issues/22)
- Major revamps on data structures available to jinja template
- Add `-t` flag to view template for a target
- Allow glob factory to use `inherit_from`.
- Improve user messages to guide when there are problems

## [0.2.0] -- 2023-01-07

- Added `-e` flag to explain a target
- Add `-i` flag to initialize an empty `_markmeld.yaml` file
- Fixed bugs with importing
- Fixed bug with prebuilds
- Allow opening files on MacOS
- Enabled using environment variables in variables
- Sort targets
- Enable multiple inheritance
- Enable recursive imports

## [0.1.0] -- 2022-11-21

### Changed

- Removed support for original beta config version
- Implemented base targets instead of inheriting from root config
- Completed refactoring and various bugfixes and tests

## [0.0.2] -- 2022-11-18

- Transitional release that can handle both original beta and version 1 config formats.


