# CommandLine

[![Version](https://img.shields.io/gem/v/command_line.svg?style=flat-square)](https://rubygems.org/gems/command_line)
[![Build](https://img.shields.io/github/workflow/status/DragonRuby/command_line/Linux?label=Test&style=flat-square)](https://github.com/DragonRuby/command_line/actions?query=workflow%3ATest)

CommandLine provides an easier way to run command-line applications.
It captures all outputs, can handle applications that require stdin, and can pass environment variables.
It's also helpful for testing commmand-line applications.

This project is tested against and works on Linux, OS X, and Windows.

## Installation

This project uses [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

Add this line to your application's Gemfile:

```ruby
gem 'command_line', '~> 2.0'
```

If you want `command_line` available globally you can add this line to your application's Gemfile:

```ruby
gem 'command_line', '~> 2.0', require: 'command_line/global'
```

Or manually install it yourself with:

```sh
$ gem install command_line
```

In a script you can make `command_line` available globally with:

```ruby
require 'command_line/global'
```

## Usage

All examples below assume that `command_line` has been made available globally.
If not, simply call `CommandLine.command_line` instead of `command_line`.

With `command_line` you to easily run commands and check their `stdout`, `stderr`, and exit status.

```ruby
>> result = command_line('echo', 'hello')
=> #<CommandLine::Result ...>
>> result.stdout
=> "hello\n"
>> result.stderr
=> ""
>> result.exited?
=> true
>> result.exitstatus
=> 0
>> result.success?
=> true
>> result.failure?
=> false
```

If your application requires input use a block to send input.

```ruby
command_line('command_expecting_input') do |stdin|
  stdin.puts "first input"
  stdin.puts "second input"
end
```

Environment variables can be passed after the command and arguments are passed.

```ruby
command_line('some_webserver', env: { PORT: '80' })
```

If you're concerned about the command running too long you can set a `:timeout`.
Exceeding the timeout will cause a `CommandLine::TimeoutError` to be raised.

```ruby
>> command_line('sleep', 5, timeout: 2)
CommandLine::TimeoutError (execution expired)
```

You can use `command_line!` if you want to raise an error on an exit failure.
The contents of `stderr` will be the error message.

```ruby
>> command_line!('grep')
CommandLine::ExitFailureError (usage: grep [-abc....
```

### RSpec

To have direct access to `CommandLine.command_line` you can include it in `spec/spec_helper.rb`.

```ruby
require 'command_line'

RSpec.configure do |config|
  config.include CommandLine
end
```

This will make `command_line` available in your test suite.
