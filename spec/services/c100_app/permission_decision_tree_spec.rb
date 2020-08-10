require 'rails_helper'

RSpec.describe C100App::PermissionDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:record)           { nil }
  let(:c100_application) { instance_double(C100Application) }

  subject {
    described_class.new(
      c100_application: c100_application,
      record: record,
      step_params: step_params,
      as: as,
      next_step: next_step
    )
  }

  it_behaves_like 'a decision tree'

  # We only test the call to the `ApplicantDecisionTree`, as the `children_relationships`
  # method is already tested in other decision trees, so no need to repeat that.
  describe '#exit_journey' do
    let(:step_params) { { parental_responsibility: 'anything' } }
    let(:record) { instance_double(Relationship, parental_responsibility: 'yes') }

    let(:applicant_decision_tree) { instance_double(C100App::ApplicantDecisionTree) }

    before do
      allow(
        C100App::ApplicantDecisionTree
      ).to receive(:new).with(
        c100_application: c100_application, record: record
      ).and_return(applicant_decision_tree)

      allow(applicant_decision_tree).to receive(:children_relationships).and_return(foo: :bar)
    end

    it 'returns the next child destination' do
      expect(subject.destination).to eq(foo: :bar)
    end
  end

  context 'when the step is `parental_responsibility`' do
    let(:step_params) { { parental_responsibility: 'anything' } }
    let(:record) { instance_double(Relationship, parental_responsibility: value) }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      it 'advances to the next question' do
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :living_order, relationship_id: record)
      end
    end
  end

  context 'when the step is `living_order`' do
    let(:step_params) { { living_order: 'anything' } }
    let(:record) { instance_double(Relationship, living_order: value) }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      # TODO: adapt tests when we add new questions
      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end
  end
end