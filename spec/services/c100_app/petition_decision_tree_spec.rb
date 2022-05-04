require 'rails_helper'

RSpec.describe C100App::PetitionDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `orders`' do
    let(:step_params) { {orders: 'anything'} }
    it {is_expected.to have_destination(:playback, :show)}
  end

  context 'when the step is `protection`' do
    let(:step_params) { {protection: 'anything'} }
    it {is_expected.to have_destination('/steps/alternatives/court', :edit)}
  end
end
