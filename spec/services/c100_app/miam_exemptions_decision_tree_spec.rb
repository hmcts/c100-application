require 'rails_helper'

RSpec.describe C100App::MiamExemptionsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `domestic`' do
    let(:step_params) { { domestic: 'anything' } }
    it { is_expected.to have_destination(:protection, :edit) }
  end

  context 'when the step is `protection`' do
    let(:step_params) { { protection: 'anything' } }
    it { is_expected.to have_destination(:urgency, :edit) }
  end

  context 'when the step is `urgency`' do
    let(:step_params) { { urgency: 'anything' } }
    it { is_expected.to have_destination(:adr, :edit) }
  end

  context 'when the step is `adr`' do
    let(:step_params) { { adr: 'anything' } }
    it { is_expected.to have_destination(:misc, :edit) }
  end

  context 'when the step is `misc`' do
    let(:c100_application) { C100Application.new(attributes) }
    let(:step_params) { { misc: 'anything' } }
    let(:attributes) {
      {
        miam_exemption: nil,
      }
    }

    context 'when there are no MIAM exemptions' do
      it { is_expected.to have_destination(:exit_page, :show) }
    end

    context 'when there are MIAM exemptions' do
      let(:attributes) { super().merge(miam_exemption: MiamExemption.new(misc: ['applicant_under_age'])) }

      it { is_expected.to have_destination(:reasons_playback, :show) }
    end
  end
end
