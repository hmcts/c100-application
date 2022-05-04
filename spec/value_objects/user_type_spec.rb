require 'rails_helper'

RSpec.describe UserType do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        applicant
        representative
      ))
    end
  end
end
