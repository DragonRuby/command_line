# frozen_string_literal: true

RSpec.shared_examples_for 'command_line' do |method|
  it 'captures stdout' do
    result = method.call('ruby', 'spec/fixtures/stdout.rb')
    expect(result.stdout).to eql 'out'
  end

  it 'captures stderr' do
    result = method.call('ruby', 'spec/fixtures/stderr.rb')
    expect(result.stderr).to eql 'err'
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
end
