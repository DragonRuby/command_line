# frozen_string_literal: true

require 'open3'
require 'timeout'

require 'command_line/result'
require 'command_line/version'

# CommandLine provides an easier way to run command-line applications.  It
# captures all outputs, can handle applications that require stdin, and can pass
# environment variables. It's also helpful for testing commmand-line
# applications.
module CommandLine
  # Top-level error class. All other errors subclass this.
  class Error < StandardError; end

  # Raised if CommandLine#command_line! is called an has an exit failure.
  class ExitFailureError < Error; end

  # Raised if a timeout is given and exceeded.
  class TimeoutError < Error; end

  module_function

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
  def command_line(command, *args, env: {}, timeout: nil)
    stdout = ''
    stderr = ''
    status = nil

    full_command = [command, *args].map(&:to_s).join(' ')
    Open3.popen3(env, full_command) do |i, o, e, wait_thr|
      threads = []

      Timeout.timeout(timeout, TimeoutError) do
        yield i if block_given?

        threads << Thread.new { stdout = o.read }
        threads << Thread.new { stderr = e.read }
        threads.each(&:join)
        status = wait_thr.value
      end
    rescue TimeoutError => e
      threads.map(&:kill)

      raise e
    end

    Result.new(stdout, stderr, status)
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
  def command_line!(*args, &block)
    command_line(*args, &block).tap do |result|
      raise ExitFailureError, result.stderr if result.failure?
    end
  end
end
