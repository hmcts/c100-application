require 'rails_helper'

RSpec.describe C100App::OtherChildrenDecisionTree do
  let(:c100_application) { double('Object') }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:record)           { nil }

  let(:c100_application) { instance_double(C100Application, other_child_ids: [1, 2, 3]) }

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

    it 'goes to edit the details of the first child' do
      expect(subject.destination).to eq(controller: :personal_details, action: :edit, id: 1)
    end
  end

  context 'when the step is `personal_details`' do
    let(:step_params) {{'personal_details' => 'anything'}}

    context 'when there are remaining children' do
      let(:record) { double('Child', id: 1) }

      it 'goes to edit the details of the next child' do
        expect(subject.destination).to eq(controller: :personal_details, action: :edit, id: 2)
      end
    end

    context 'when all children have been edited' do
      let(:record) { double('Child', id: 3) }
      it {is_expected.to have_destination('/steps/applicant/names', :edit)}
    end
  end
end
