# frozen_string_literal: true

require 'command_line/global'

RSpec.describe 'globally includes command_line' do
  include_examples 'command_line', method(:command_line)
  include_examples 'command_line!', method(:command_line!)
end
