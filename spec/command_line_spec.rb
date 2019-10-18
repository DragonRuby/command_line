# frozen_string_literal: true

RSpec.describe 'CommandLine' do
  include_examples 'command_line', CommandLine.method(:command_line)
  include_examples 'command_line!', CommandLine.method(:command_line!)
end
