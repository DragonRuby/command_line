# frozen_string_literal: true

module CommandLine
  # The result returned from running {CommandLine.command_line}.
  class Result
    def initialize(stdout, stderr, status)
      @stdout = stdout
      @stderr = stderr
      @status = status
    end

    # The complete contents of stdout after running the application.
    #
    # @example
    #   command_line('echo', 'hi').stdout
    #   # => "hi\n"
    #
    # @return [String]
    attr_reader :stdout

    # The complete contents of stderr after running the application.
    #
    # @example
    #   command_line('grep').stderr
    #   # => "usage: grep ..."
    #
    # @return [String]
    attr_reader :stderr

    # Returns true if the application exited normally.
    #
    # @example
    #   command_line('grep').exited?
    #
    # @return [Boolean]
    def exited?
      @status.exited?
    end

    # The numeric exit status of the application if it exited normally.
    #
    # @example
    #   command_line('echo', 'hi').exitstatus
    #   # => 0
    #   command_line('grep').exitstatus
    #   # => 2
    #
    # @return [Integer, nil]
    def exitstatus
      @status.exitstatus
    end

    # Returns true if the command exited normally with a success status.
    #
    # @example
    #   command_line('echo', 'hi').success?
    #   # => true
    #
    # @return [Boolean]
    def success?
      !@status.nil? && @status.success?
    end

    # Returns true if the command failed to exit normally or exited with a
    # failing status.
    #
    # @example
    #   command_line('grep').failure?
    #   # => true
    #
    # @return [Boolean]
    def failure?
      !success?
    end
  end
end
