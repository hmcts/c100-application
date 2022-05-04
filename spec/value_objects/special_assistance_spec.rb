require 'rails_helper'

RSpec.describe SpecialAssistance do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        hearing_loop
        braille_documents
        advance_court_viewing
        other_assistance
      ))
    end
  end
end
