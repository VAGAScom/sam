# frozen_string_literal: true

RSpec.describe 'hanami version', type: :cli do
  it 'prints the current version' do
    run_command 'sam version', Sam::VERSION
  end
end
