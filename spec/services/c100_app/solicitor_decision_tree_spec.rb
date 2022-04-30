require 'rails_helper'

RSpec.describe C100App::SolicitorDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `personal_details`' do
    let(:step_params) { { personal_details: 'anything' } }
    it { is_expected.to have_destination(:address_details, :edit) }
  end

  context 'when the step is `address_details`' do
    let(:step_params) { { address_details: 'anything' } }
    it { is_expected.to have_destination(:contact_details, :edit) }
  end

  context 'when the step is `contact_details`' do
    let(:step_params) { { contact_details: 'anything' } }
    it { is_expected.to have_destination('/steps/respondent/names', :edit) }
  end
end
