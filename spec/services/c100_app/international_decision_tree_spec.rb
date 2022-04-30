require 'rails_helper'

RSpec.describe C100App::InternationalDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `resident`' do
    let(:step_params) { { resident: 'anything' } }
    it { is_expected.to have_destination(:jurisdiction, :edit) }
  end

  context 'when the step is `jurisdiction`' do
    let(:step_params) { { jurisdiction: 'anything' } }
    it { is_expected.to have_destination(:request, :edit) }
  end

  context 'when the step is `request`' do
    let(:step_params) { { request: 'anything' } }
    let(:rules_mock)  { double(permission_needed?: rule_result, reset_permission_details!: true) }

    before do
      allow(C100App::Permission::ApplicationRules).to receive(:new).with(c100_application).and_return(rules_mock)
    end

    context 'when permission to apply is needed' do
      let(:rule_result) { true }
      it { is_expected.to have_destination('/steps/application/permission_sought', :edit) }
    end

    context 'when permission to apply is not needed' do
      let(:rule_result) { false }

      it 'resets the permission details, in case these exists, and continue to application details' do
        expect(subject).to have_destination('/steps/application/details', :edit)
        expect(rules_mock).to have_received(:reset_permission_details!)
      end
    end
  end
end
