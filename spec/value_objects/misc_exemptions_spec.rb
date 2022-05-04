require 'rails_helper'

RSpec.describe MiscExemptions do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  context 'NO_RESPONDENT_ADDRESS' do
    it 'returns the expected values' do
      expect(described_class::NO_RESPONDENT_ADDRESS.to_s).to eq('no_respondent_address')
    end
  end

  context 'WITHOUT_NOTICE' do
    it 'returns the expected values' do
      expect(described_class::WITHOUT_NOTICE.to_s).to eq('without_notice')
    end
  end

  describe 'MIAM access exemptions' do
    context 'GROUP_MIAM_ACCESS' do
      it 'returns the expected values' do
        expect(described_class::GROUP_MIAM_ACCESS.to_s).to eq('group_miam_access')
      end
    end

    context 'MIAM_ACCESS' do
      it 'returns the expected values' do
        expect(described_class::MIAM_ACCESS.map(&:to_s)).to eq(%w(
          no_disabled_facilities
          no_appointment
          no_mediator_nearby
        ))
      end
    end
  end

  context 'ACCESS_PROHIBITED' do
    it 'returns the expected values' do
      expect(described_class::ACCESS_PROHIBITED.to_s).to eq('access_prohibited')
    end
  end

  context 'NON_RESIDENT' do
    it 'returns the expected values' do
      expect(described_class::NON_RESIDENT.to_s).to eq('non_resident')
    end
  end

  context 'MISC_NONE' do
    it 'returns the expected values' do
      expect(described_class::MISC_NONE.to_s).to eq('misc_none')
    end
  end
end
