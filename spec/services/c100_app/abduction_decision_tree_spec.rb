require 'rails_helper'

RSpec.describe C100App::AbductionDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `international`' do
    let(:step_params) { { international: 'anything' } }
    it { is_expected.to have_destination(:children_have_passport, :edit) }
  end

  context 'when the step is `children_have_passport`' do
    let(:step_params) { { children_have_passport: value } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:passport_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:previous_attempt, :edit) }
    end
  end

  context 'when the step is `passport_details`' do
    let(:step_params) { { passport_details: 'anything' } }
    it { is_expected.to have_destination(:previous_attempt, :edit) }
  end

  context 'when the step is `previous_attempt`' do
    let(:step_params) { { previous_attempt: value } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:previous_attempt_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:risk_details, :edit) }
    end
  end

  context 'when the step is `previous_attempt_details`' do
    let(:step_params) { { previous_attempt_details: 'anything' } }
    it { is_expected.to have_destination(:risk_details, :edit) }
  end

  context 'when the step is `risk_details`' do
    let(:step_params) { { risk_details: 'anything' } }
    it { is_expected.to have_destination('/steps/safety_questions/substance_abuse', :edit) }
  end
end
