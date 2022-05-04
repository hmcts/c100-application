require 'rails_helper'

RSpec.describe C100App::OpeningDecisionTree do
  let(:postcode)         { 'anything' }
  let(:local_court)      { {} }
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(c100_application: c100_application, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `children_postcode`' do
    let(:step_params) { { children_postcode: postcode } }

    context 'and no valid court is found' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).with(postcode).and_return(nil)
      end
      it { is_expected.to have_destination(:no_court_found, :show) }
    end

    context 'and one valid court is found' do
      let(:court) { instance_double('Court') }

      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).with(postcode).and_return(court)
        allow(c100_application).to receive(:update!)
      end

      it 'assigns the court to the c100 application' do
        expect(subject).to receive(:show_research_consent?)
        expect(c100_application).to receive(:update!).with(court: court)

        is_expected.to have_destination(:consent_order, :edit)
      end

      context 'research consent step' do
        before do
          allow(c100_application).to receive(:created_at).and_return(Time.at(seconds))
          allow(Rails.configuration.x.opening).to receive(:research_consent_weight).and_return(25)
        end

        context 'the research consent step is shown to this user' do
          let(:seconds) { 10 }
          it { is_expected.to have_destination(:research_consent, :edit) }
        end

        context 'the research consent step is not shown to this user' do
          let(:seconds) { 30 }
          it { is_expected.to have_destination(:consent_order, :edit) }
        end
      end
    end

    context 'when the postcode checker raises an error' do
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end

    context 'when the postcode is nil' do
      let(:postcode){ nil }
      before do
        allow_any_instance_of(C100App::CourtPostcodeChecker).to receive(:court_for).and_raise("expected exception for testing, please ignore")
      end
      it { is_expected.to have_destination(:error_but_continue, :show)}
    end
  end

  context 'when the step is `research_consent`' do
    let(:c100_application) { instance_double(C100Application, research_consent: value) }
    let(:step_params) { { research_consent: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:consent_order, :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:consent_order, :edit) }
    end
  end

  context 'when the step is `consent_order`' do
    let(:c100_application) { instance_double(C100Application, consent_order: value) }
    let(:step_params) { { consent_order: 'anything' } }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination(:consent_order_sought, :show) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination(:child_protection_cases, :edit) }
    end
  end

  context 'when the step is `child_protection_cases`' do
    let(:c100_application) { instance_double(C100Application, child_protection_cases: value, consent_order: consent_value) }
    let(:step_params) { { child_protection_cases: 'anything' } }

    context 'when the answer to the consent order was `yes`' do
      let(:consent_value) { 'yes' }

      context 'and the answer is `yes`' do
        let(:value) { 'yes' }
        it { is_expected.to have_destination('/steps/safety_questions/start', :show) }
      end

      context 'and the answer is `no`' do
        let(:value) { 'no' }
        it { is_expected.to have_destination('/steps/safety_questions/start', :show) }
      end
    end

    context 'when the answer to the consent order was `no`' do
      let(:consent_value) { 'no' }

      context 'and the answer is `yes`' do
        let(:value) { 'yes' }
        it { is_expected.to have_destination(:child_protection_info, :show) }
      end

      context 'and the answer is `no`' do
        let(:value) { 'no' }
        it { is_expected.to have_destination('/steps/miam/acknowledgement', :edit) }
      end
    end

    context 'when there is no consent order value (behaves like `no`)' do
      let(:consent_value) { nil }

      context 'and the answer is `yes`' do
        let(:value) { 'yes' }
        it { is_expected.to have_destination(:child_protection_info, :show) }
      end

      context 'and the answer is `no`' do
        let(:value) { 'no' }
        it { is_expected.to have_destination('/steps/miam/acknowledgement', :edit) }
      end
    end
  end
end
