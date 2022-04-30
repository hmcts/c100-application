require 'rails_helper'

RSpec.describe DomesticExemptions do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe 'Police exemptions' do
    context 'GROUP_POLICE' do
      it 'returns the expected values' do
        expect(described_class::GROUP_POLICE.to_s).to eq('group_police')
      end
    end

    context 'POLICE' do
      it 'returns the expected values' do
        expect(described_class::POLICE.map(&:to_s)).to eq(%w(
          police_arrested
          police_caution
          police_ongoing_proceedings
          police_conviction
          police_dvpn
        ))
      end
    end
  end

  describe 'Court exemptions' do
    context 'GROUP_COURT' do
      it 'returns the expected values' do
        expect(described_class::GROUP_COURT.to_s).to eq('group_court')
      end
    end

    context 'COURT' do
      it 'returns the expected values' do
        expect(described_class::COURT.map(&:to_s)).to eq(%w(
          court_bound_over
          court_protective_injunction
          court_undertaking
          court_finding_of_fact
          court_expert_report
        ))
      end
    end
  end

  describe 'Specialist exemptions' do
    context 'GROUP_SPECIALIST' do
      it 'returns the expected values' do
        expect(described_class::GROUP_SPECIALIST.to_s).to eq('group_specialist')
      end
    end

    context 'SPECIALIST' do
      it 'returns the expected values' do
        expect(described_class::SPECIALIST.map(&:to_s)).to eq(%w(
          specialist_examination
          specialist_referral
        ))
      end
    end
  end

  describe 'LA exemptions' do
    context 'GROUP_LOCAL_AUTHORITY' do
      it 'returns the expected values' do
        expect(described_class::GROUP_LOCAL_AUTHORITY.to_s).to eq('group_local_authority')
      end
    end

    context 'LOCAL_AUTHORITY' do
      it 'returns the expected values' do
        expect(described_class::LOCAL_AUTHORITY.map(&:to_s)).to eq(%w(
          local_authority_marac
          local_authority_la_ha
          local_authority_public_authority
        ))
      end
    end
  end

  describe 'DA Service exemptions' do
    context 'GROUP_DA_SERVICE' do
      it 'returns the expected values' do
        expect(described_class::GROUP_DA_SERVICE.to_s).to eq('group_da_service')
      end
    end

    context 'DA_SERVICE' do
      it 'returns the expected values' do
        expect(described_class::DA_SERVICE.map(&:to_s)).to eq(%w(
          da_service_idva
          da_service_isva
          da_service_organisation
          da_service_refuge_refusal
        ))
      end
    end
  end

  context 'RIGHT_TO_REMAIN' do
    it 'returns the expected values' do
      expect(described_class::RIGHT_TO_REMAIN.to_s).to eq('right_to_remain')
    end
  end

  context 'FINANCIAL_ABUSE' do
    it 'returns the expected values' do
      expect(described_class::FINANCIAL_ABUSE.to_s).to eq('financial_abuse')
    end
  end

  context 'DOMESTIC_NONE' do
    it 'returns the expected values' do
      expect(described_class::DOMESTIC_NONE.to_s).to eq('domestic_none')
    end
  end
end
