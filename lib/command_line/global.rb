# frozen_string_literal: true

require 'command_line'

# Docs are included here so they can be discovered.

# Run a command and get back the result.
#
# @param command [String] The command to run.
# @param args [Array] Any arguments passed to the command. All arguments will
#   be converted to strings using `to_s`.
# @param [Hash] env: Pass environment variables to use. The key should
#   be a String representing the environment variable name. The value
#   is the value you want that variable to have.
# @param [Integer, Float, nil] Number of seconds to wait for the block to
#   terminate. Floats can be used to specify fractional seconds. A value of 0
#   or nil will execute the block without any timeout.
#
# @yield [stdin] Handle any input on stdin that the command needs.
# @yieldparam stdin [IO]
#
# @example
#   command_line('echo', 'hello')
#
# @example
#   command_line('command_expecting_input') do |stdin|
#     stdin.puts "first input"
#     stdin.puts "second input"
#   end
#
# @example
#   command_line('some_webserver', env: { 'PORT' => '80' })
#
# @return [Result]
def command_line(*args, **kwargs, &block)
  CommandLine.command_line(*args, **kwargs, &block)
end

# Same as CommandLine.command_line except that a failure on exit raises an
# error.
#
# @see CommandLine.command_line
#
# @example
#   command_line!('echo', 'hello')
#
# @example
#   command_line!('grep')
#   # => CommandLine::ExitFailureError (usage: grep ...
#
# @return [Result]
# @raise [CommandLine::ExitFailureError] If the application exits with an
#   error status. The message will be the contents of Result#stderr.
def command_line!(*args, **kwargs, &block)
  CommandLine.command_line!(*args, **kwargs, &block)
end
