# CommandLine

CommandLine provides an easier way to run command-line applications.
It captures all outputs, can handle applications that require stdin, and can pass environment variables.
It's also helpful for testing commmand-line applications.

## Installation

This project uses [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

Add this line to your application's Gemfile:

```ruby
gem 'command_line', '~> 0.1.0'
```

If you want `command_line` available everywhere you can add this line to your application's Gemfile:

```ruby
gem 'command_line', '~> 0.1.0', require: 'command_line/global'
```

Or manually install it yourself with:

```sh
$ gem install command_line
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
command_line('some_webserver', { 'PORT' => '80' })
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DragonRuby/command_line.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
