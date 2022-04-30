require 'rails_helper'

RSpec.describe C100App::MiamDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  let(:c100_application) { instance_double(C100Application) }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `miam_acknowledgement`' do
    let(:step_params) { { miam_acknowledgement: 'anything' } }
    it { is_expected.to have_destination(:attended, :edit) }
  end

  context 'when the step is `miam_attended`' do
    let(:c100_application) { instance_double(C100Application, miam_attended: value) }
    let(:step_params) { { miam_attended: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:certification, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:mediator_exemption, :edit) }
    end
  end

  context 'when the step is `miam_mediator_exemption`' do
    let(:c100_application) { instance_double(C100Application, miam_mediator_exemption: value) }
    let(:step_params) { { miam_mediator_exemption: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:certification, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:exemption_claim, :edit) }
    end
  end

  context 'when the step is `miam_exemption_claim`' do
    let(:c100_application) { instance_double(C100Application, miam_exemption_claim: value) }
    let(:step_params) { { miam_exemption_claim: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/miam_exemptions/domestic', :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination('/steps/miam_exemptions/exit_page', :show) }
    end
  end

  context 'when the step is `miam_certification`' do
    let(:c100_application) { instance_double(C100Application, miam_certification: value) }
    let(:step_params) { { miam_certification: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:certification_date, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:certification_exit, :show) }
    end
  end

  context 'when the step is `miam_certification_date`' do
    let(:c100_application) { instance_double(C100Application, miam_certification_date: value.to_date) }
    let(:step_params) { { miam_certification_date: 'anything' } }
    let(:value) { 6.months.ago }

    it { is_expected.to have_destination(:certification_details, :edit) }
  end

  context 'when the step is `miam_certification_details`' do
    let(:step_params) {{miam_certification_details: 'anything'}}
    it {is_expected.to have_destination(:certification_confirmation, :show)}
  end
end
