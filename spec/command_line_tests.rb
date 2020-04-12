# frozen_string_literal: true

RSpec.shared_examples_for 'command_line' do |method|
  it 'runs the command and arguments as a single call' do
    Bundler.with_unbundled_env do
      result = command_line('bundle exec rake', '-T')
      expect(result.stdout).to_not be_empty
    end
  end

  it 'captures stdout' do
    result = method.call('ruby', 'spec/fixtures/stdout.rb')
    expect(result.stdout).to eql 'out'
  end

  it 'captures massive stdout without hanging' do
    result = method.call('ruby', 'spec/fixtures/massive_stdout.rb')
    expect(result.stdout).to start_with 'out'
  end

  it 'captures stderr' do
    result = method.call('ruby', 'spec/fixtures/stderr.rb')
    expect(result.stderr).to eql 'err'
  end

  it 'captures massive stderr without hanging' do
    result = method.call('ruby', 'spec/fixtures/massive_stderr.rb')
    expect(result.stderr).to start_with 'err'
  end

  it 'captures both stdout and stderr' do
    result = method.call('ruby', 'spec/fixtures/stdout_and_stderr.rb')
    expect(result.stdout).to eql 'out'
    expect(result.stderr).to eql 'err'
  end

  it 'captures both massive stdout and massive stderr' do
    result = method.call('ruby', 'spec/fixtures/massive_stdout_and_stderr.rb')
    expect(result.stdout).to start_with 'out'
    expect(result.stderr).to start_with 'err'
  end

  it 'captures the exit status' do
    result = method.call('ruby', 'spec/fixtures/exit_status_success.rb')
    expect(result).to be_exited
    expect(result).to be_success
    expect(result.exitstatus).to eql 0

    result = method.call('ruby', 'spec/fixtures/exit_status_failure.rb')
    expect(result).to be_exited
    expect(result).to be_failure
    expect(result.exitstatus).to eql 1
  end

  it 'allows for input' do
    first_input = "hi\n"
    second_input = "bye\n"

    result = method.call('ruby', 'spec/fixtures/echos_inputs.rb') do |stdin|
      stdin.print first_input
      stdin.print second_input
    end

    expect(result.stdout).to eql "#{first_input}#{second_input}"
  end

  context 'with :env' do
    it 'uses the ENV variables' do
      expect(
        method.call('ruby', 'spec/fixtures/echo_env.rb').stdout
      ).to eql "\n"

      echo = 'hi'

      # with strings
      expect(
        method.call('ruby', 'spec/fixtures/echo_env.rb', env: {
          'ECHO' => echo
        }).stdout
      ).to eql "#{echo}\n"
    end
  end

  context 'with :timeout' do
    context 'is nil' do
      it 'does not time out' do
        expect(
          method.call('ruby', 'spec/fixtures/sleep.rb', 2, timeout: nil)
        ).to be_success
      end
    end

    context 'is 0' do
      it 'does not time out' do
        expect(
          method.call('ruby', 'spec/fixtures/sleep.rb', 2, timeout: 0)
        ).to be_success
      end
    end

    context 'is 3' do
      it 'does not time out if timeout is > 3' do
        expect(
          method.call('ruby', 'spec/fixtures/sleep.rb', 3, timeout: 4)
        ).to be_success
      end

      it 'does t time out if timeout is < 3' do
        expect do
          method.call('ruby', 'spec/fixtures/sleep.rb', 3, timeout: 2)
        end.to raise_error(CommandLine::TimeoutError, 'execution expired')
      end
    end
  end
end
