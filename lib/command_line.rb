# frozen_string_literal: true

require 'open3'

require 'command_line/result'
require 'command_line/version'

# CommandLine provides an easier way to run command-line applications.  It
# captures all outputs, can handle applications that require stdin, and can pass
# environment variables. It's also helpful for testing commmand-line
# applications.
module CommandLine
  module_function

  # Run a command and get back the result.
  #
  # @param command [String] the command to run
  # @param args [Array<String>] any arguments passed to the command
  # @param [Hash] env: Pass environment variables to use. The key should
  #   be a String representing the environment variable name. The value
  #   is the value you want that variable to have.
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
  #   command_line('some_webserver', { 'PORT' => '80' })
  #
  # @return [Result]
  def command_line(command, *args, env: {})
    stdout = ''
    stderr = ''
    status = nil

    Open3.popen3(env, command, *args) do |i, o, e, wait_thr|
      yield i if block_given?

      [
        Thread.new { stdout = o.read },
        Thread.new { stderr = e.read }
      ].each(&:join)
      status = wait_thr.value
    end

    Result.new(stdout, stderr, status)
  end
end
