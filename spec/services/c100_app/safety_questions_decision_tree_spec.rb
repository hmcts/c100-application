require 'rails_helper'

RSpec.describe C100App::SafetyQuestionsDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `address_confidentiality`' do
    let(:step_params) { { 'address_confidentiality' => 'anything' } }
    it { is_expected.to have_destination(:risk_of_abduction, :edit) }
  end

  context 'when the step is `risk_of_abduction`' do
    let(:c100_application) { instance_double(C100Application, risk_of_abduction: value) }
    let(:step_params) { { risk_of_abduction: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/abduction/international', :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:substance_abuse, :edit) }
    end
  end

  context 'when the step is `substance_abuse`' do
    let(:c100_application) {
      instance_double(C100Application, substance_abuse: value, risk_of_abduction: risk_value)
    }
    let(:step_params) { { substance_abuse: 'anything' } }
    let(:risk_value) { nil }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/abuse_concerns/start', :show) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      context 'and the answer to `risk of abduction` was `yes`' do
        let(:risk_value) { 'yes' }
        it { is_expected.to have_destination('/steps/abuse_concerns/start', :show) }
      end

      context 'and the answer to `risk of abduction` was `no`' do
        let(:risk_value) { 'no' }
        it { is_expected.to have_destination(:children_abuse, :edit) }
      end
    end
  end

  context 'when the step is `children_abuse`' do
    let(:c100_application) { instance_double(C100Application, children_abuse: value) }
    let(:step_params) { { children_abuse: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/abuse_concerns/start', :show) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:domestic_abuse, :edit) }
    end
  end

  context 'when the step is `domestic_abuse`' do
    let(:c100_application) { instance_double(C100Application, domestic_abuse: value) }
    let(:step_params) { { domestic_abuse: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/abuse_concerns/start', :show) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:other_abuse, :edit) }
    end
  end

  context 'when the step is `other_abuse`' do
    let(:c100_application) { instance_double(C100Application, other_abuse: value) }
    let(:step_params) { { other_abuse: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/abuse_concerns/start', :show) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination('/steps/petition/orders', :edit) }
    end
  end
end
