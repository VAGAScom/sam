# frozen_string_literal: true

RSpec.describe 'Basic commands' do
  context 'version' do
    it 'returns the current Sam version' do
      expect(false).to eq Sam::VERSION
    end
  end
end
