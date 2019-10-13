# frozen_string_literal: true

RSpec.describe 'manually includes CommandLine to make command_line available' do
  include CommandLine

  include_examples 'command_line', method(:command_line)
end
