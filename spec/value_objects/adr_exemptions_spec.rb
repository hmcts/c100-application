require 'rails_helper'

RSpec.describe AdrExemptions do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  context 'PREVIOUS_ADR' do
    it 'returns the expected values' do
      expect(described_class::PREVIOUS_ADR.map(&:to_s)).to eq(%w(
        previous_attendance
        ongoing_attendance
        existing_proceedings_attendance
      ))
    end
  end

  context 'PREVIOUS_MIAM' do
    it 'returns the expected values' do
      expect(described_class::PREVIOUS_MIAM.map(&:to_s)).to eq(%w(
        previous_exemption
        existing_proceedings_exemption
      ))
    end
  end

  context 'ADR_NONE' do
    it 'returns the expected values' do
      expect(described_class::ADR_NONE.to_s).to eq('adr_none')
    end
  end
end
