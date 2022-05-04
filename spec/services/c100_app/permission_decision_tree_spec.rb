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

      it 'advances to the next question' do
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :amendment, relationship_id: record)
      end
    end
  end

  context 'when the step is `amendment`' do
    let(:step_params) { { amendment: 'anything' } }
    let(:record) { instance_double(Relationship, amendment: value) }

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
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :time_order, relationship_id: record)
      end
    end
  end

  context 'when the step is `time_order`' do
    let(:step_params) { { time_order: 'anything' } }
    let(:record) { instance_double(Relationship, time_order: value) }

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
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :living_arrangement, relationship_id: record)
      end
    end
  end

  context 'when the step is `living_arrangement`' do
    let(:step_params) { { living_arrangement: 'anything' } }
    let(:record) { instance_double(Relationship, living_arrangement: value) }

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
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :consent, relationship_id: record)
      end
    end
  end

  context 'when the step is `consent`' do
    let(:step_params) { { consent: 'anything' } }
    let(:record) { instance_double(Relationship, consent: value) }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      it 'exists the journey' do
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :family, relationship_id: record)
      end
    end
  end

  context 'when the step is `family`' do
    let(:step_params) { { family: 'anything' } }
    let(:record) { instance_double(Relationship, family: value) }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      it 'exists the journey' do
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :local_authority, relationship_id: record)
      end
    end
  end

  context 'when the step is `local_authority`' do
    let(:step_params) { { local_authority: 'anything' } }
    let(:record) { instance_double(Relationship, local_authority: value) }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      it 'exists the journey' do
        expect(subject.destination).to eq(controller: :question, action: :edit, question_name: :relative, relationship_id: record)
      end
    end
  end

  context 'when the step is `relative`' do
    let(:step_params) { { relative: 'anything' } }
    let(:record) { instance_double(Relationship, relative: value) }

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }

      it 'exists the journey' do
        expect(subject).to receive(:exit_journey)
        subject.destination
      end
    end
  end
end
