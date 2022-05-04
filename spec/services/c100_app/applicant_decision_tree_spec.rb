require 'rails_helper'

RSpec.describe C100App::ApplicantDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:record)           { nil }

  let(:c100_application) { instance_double(C100Application, applicant_ids: [1, 2, 3], minor_ids: [1, 2, 3]) }

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

  context 'when the step is `add_another_name`' do
    let(:step_params) {{'add_another_name' => 'anything'}}
    it {is_expected.to have_destination(:names, :edit)}
  end

  context 'when the step is `names_finished`' do
    let(:step_params) {{'names_finished' => 'anything'}}

    it 'goes to edit the details of the first applicant' do
      expect(subject.destination).to eq(controller: :personal_details, action: :edit, id: 1)
    end
  end

  context 'when the step is `personal_details`' do
    let(:step_params) {{'personal_details' => 'anything'}}
    let(:record) { double('Applicant', id: 1, dob: dob) }

    before do
      expect(record).to receive(:reload).and_return(record)
      travel_to Date.new(2018, 1, 5) # Stub current date to 5 Jan 2018
    end

    context 'and the DoB is under age' do
      let(:dob) { Date.new(2000, 1, 6) }

      it 'goes to the warning under age page' do
        expect(subject.destination).to eq(controller: :under_age, action: :edit, id: record)
      end
    end

    context 'and the DoB is not under age' do
      let(:dob) { Date.new(2000, 1, 5) }

      it 'goes to edit the first child relationship for the current record' do
        expect(subject.destination).to eq(controller: :relationship, action: :edit, id: record, child_id: 1)
      end
    end
  end

  context 'when the step is `under_age`' do
    let(:step_params) {{'under_age' => 'anything'}}
    let(:record) {double('Applicant', id: 1)}

    it 'goes to edit the first child relationship for the current record' do
      expect(subject.destination).to eq(controller: :relationship, action: :edit, id: record, child_id: 1)
    end
  end

  context 'when the step is `relationship`' do
    let(:step_params) {{'relationship' => 'anything'}}
    let(:record) { double('Relationship', person: applicant, minor: child) }

    let(:applicant) { Applicant.new }

    let(:rules_mock) { double(permission_undecided?: rule_result) }

    before do
      allow(C100App::Permission::RelationshipRules).to receive(:new).with(record).and_return(rules_mock)
    end

    context 'when permission might be needed' do
      let(:child) { double('Child', id: 1) }
      let(:rule_result) { true }

      it 'goes to edit the relationship of the next child' do
        expect(subject.destination).to eq(controller: '/steps/permission/question', action: :edit, question_name: :parental_responsibility, relationship_id: record)
      end
    end

    context 'when permission is not needed' do
      let(:rule_result) { false }

      context 'when there are remaining children' do
        let(:child) { double('Child', id: 1) }

        it 'goes to edit the relationship of the next child' do
          expect(subject.destination).to eq(controller: '/steps/applicant/relationship', action: :edit, id: applicant, child_id: 2)
        end
      end

      context 'when all child relationships have been edited' do
        let(:child) { double('Child', id: 3) }

        include_examples 'address lookup decision tree' do
          let(:person) { applicant }
          let(:namespace) { 'applicant' }
        end
      end
    end
  end

  context 'when the step is `address_details`' do
    let(:step_params) {{'address_details' => 'anything'}}
    let(:record) { double('Applicant', id: 3) }

    it 'goes to edit the contact details of the current applicant' do
      expect(subject.destination).to eq(controller: :contact_details, action: :edit, id: record)
    end
  end

  context 'when the step is `contact_details`' do
    let(:step_params) {{'contact_details' => 'anything'}}

    context 'when there are remaining applicants' do
      let(:record) { double('Applicant', id: 1) }

      it 'goes to edit the personal details of the next applicant' do
        expect(subject.destination).to eq(controller: :personal_details, action: :edit, id: 2)
      end
    end

    context 'when all applicants have been edited' do
      let(:record) { double('Applicant', id: 3) }
      it { is_expected.to have_destination(:has_solicitor, :edit) }
    end
  end

  context 'when the step is `has_solicitor`' do
    let(:step_params) { { has_solicitor: 'anything' } }

    before do
      allow(c100_application).to receive(:has_solicitor).and_return(value)
    end

    context 'and the answer is `yes`' do
      let(:value) { 'yes' }
      it { is_expected.to have_destination('/steps/solicitor/personal_details', :edit) }
    end

    context 'and the answer is `no`' do
      let(:value) { 'no' }
      it { is_expected.to have_destination('/steps/respondent/names', :edit) }
    end
  end
end
