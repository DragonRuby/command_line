# frozen_string_literal: true

RSpec.shared_examples_for 'command_line!' do |method|
  it 'returns Result on success' do
    result = method.call('ruby', 'spec/fixtures/exit_status_success.rb')

    expect(result).to be_an_instance_of(CommandLine::Result)
    expect(result).to be_success
  end

  it 'errors on failure' do
    expect do
      method.call('ruby', 'spec/fixtures/exit_status_failure.rb')
    end.to raise_error(CommandLine::ExitFailureError, 'Error!')
  end
end
