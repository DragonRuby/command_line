# [2.0.1] (2020-04-17)

## Fixed

- Deprecation warning about keyword arguments.

# [2.0.0] (2020-04-13)

## Changed

- Arguments are now always sent as a single command to `Open3.popen3`. Sending as multiple arguments can cause it to not use the shell. Passing as a single argument ensures the shell is always used.
- Drop support for Ruby 2.4.

## Added

- The `:env` flag now accepts non-string keys and will convert them to strings.

## Fixed

- Deprecation warning about keyword arguments.

# [1.1.0] (2019-10-23)

## Added

- CommandLine.command_line!
- Added a `:timeout` argument for setting a timeout.
- Allow more than strings as arguments to pass to the command. We'll convert everything with `to_s`.

# [1.0.1] (2019-08-16)

## Fixed

- Massive output on stdout or stderr could block forever.

# 1.0.0 (2019-08-15)

Initial release.

[2.0.1]: https://github.com/DragonRuby/command_line/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/DragonRuby/command_line/compare/v1.1.0...v2.0.0
[1.1.0]: https://github.com/DragonRuby/command_line/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/DragonRuby/command_line/compare/v1.0.0...v1.0.1
