require 'rails_helper'

RSpec.describe C100App::CourtOrdersDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `has_court_orders`' do
    let(:c100_application) { instance_double(C100Application, has_court_orders: answer) }
    let(:step_params) { { has_court_orders: 'whatever' } }

    context 'and the answer is `yes`' do
      let(:answer) { 'yes' }
      it { is_expected.to have_destination(:details, :edit) }
    end

    context 'and the answer is `no`' do
      let(:answer) { 'no' }
      it { is_expected.to have_destination('/steps/abuse_concerns/contact', :edit) }
    end
  end

  context 'when the step is `orders_details`' do
    let(:step_params) { { orders_details: 'whatever' } }
    it { is_expected.to have_destination('/steps/abuse_concerns/contact', :edit) }
  end
end
