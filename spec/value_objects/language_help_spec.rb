require 'rails_helper'

RSpec.describe LanguageHelp do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        language_interpreter
        sign_language_interpreter
        welsh_language
      ))
    end
  end
end
