require 'rails_helper'

RSpec.describe C100App::ApplicationDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  describe 'when the step is `previous_proceedings`' do
    let(:c100_application) { instance_double(C100Application, children_previous_proceedings: answer) }
    let(:step_params) { { previous_proceedings: 'whatever' } }

    context 'when answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:court_proceedings, :edit) }
    end

    context 'when answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:urgent_hearing, :edit) }
    end
  end

  context 'when the step is `court_proceedings`' do
    let(:step_params) { { court_proceedings: 'anything' } }
    it { is_expected.to have_destination(:urgent_hearing, :edit) }
  end

  context 'when the step is `urgent_hearing`' do
    let(:c100_application) { instance_double(C100Application, urgent_hearing: answer) }
    let(:step_params) { { urgent_hearing: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:urgent_hearing_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:without_notice, :edit) }
    end
  end

  context 'when the step is `urgent_hearing_details`' do
    let(:step_params) { { urgent_hearing_details: 'anything' } }
    it { is_expected.to have_destination(:without_notice, :edit) }
  end

  context 'when the step is `without_notice`' do
    let(:c100_application) { instance_double(C100Application, without_notice: answer) }
    let(:step_params) { { without_notice: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:without_notice_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination('/steps/international/resident', :edit) }
    end
  end

  context 'when the step is `without_notice_details`' do
    let(:step_params) { { without_notice_details: 'anything' } }
    it { is_expected.to have_destination('/steps/international/resident', :edit) }
  end

  context 'when the step is `permission_sought`' do
    let(:c100_application) { instance_double(C100Application, permission_sought: answer) }
    let(:step_params) { { permission_sought: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination(:permission_details, :edit) }
    end
  end

  context 'when the step is `permission_details`' do
    let(:step_params) { { permission_details: 'anything' } }
    it { is_expected.to have_destination(:details, :edit) }
  end

  context 'when the step is `application_details`' do
    let(:step_params) { { application_details: 'anything' } }
    it { is_expected.to have_destination(:litigation_capacity, :edit) }
  end

  context 'when the step is `litigation_capacity`' do
    let(:c100_application) { instance_double(C100Application, reduced_litigation_capacity: answer) }
    let(:step_params) { { litigation_capacity: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:litigation_capacity_details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination('/steps/attending_court/intermediary', :edit) }
    end
  end

  context 'when the step is `litigation_capacity_details`' do
    let(:step_params) { { litigation_capacity_details: 'anything' } }
    it { is_expected.to have_destination('/steps/attending_court/intermediary', :edit) }
  end

  context 'when the step is `submission`' do
    let(:step_params) { { submission: 'anything' } }
    let(:c100_application) { instance_double(C100Application, receipt_email: receipt_email) }

    context 'and user chose to receive a confirmation email' do
      let(:receipt_email) { 'test@example.com' }
      it { is_expected.to have_destination(:receipt_email_check, :show) }
    end

    context 'and user left blank the confirmation email' do
      let(:receipt_email) { '' }
      it { is_expected.to have_destination(:payment, :edit) }
    end

    context 'and user do not want online submission' do
      let(:receipt_email) { nil }
      it { is_expected.to have_destination(:payment, :edit) }
    end
  end

  context 'when the step is `payment`' do
    let(:step_params) { { payment: 'anything' } }
    it { is_expected.to have_destination(:check_your_answers, :edit) }
  end

  context 'when the step is `declaration`' do
    let(:step_params) { { declaration: 'anything' } }
    let(:flow_double) { double(payment_url: 'https://payments.example.com') }

    it 'calls the payments flow control and returns the destination URL' do
      expect(
        C100App::PaymentsFlowControl
      ).to receive(:new).with(c100_application).and_return(flow_double)

      expect(subject.destination).to eq('https://payments.example.com')
    end
  end
end
