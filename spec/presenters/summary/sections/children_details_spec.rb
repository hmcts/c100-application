require 'spec_helper'

module Summary
  describe Sections::ChildrenDetails do
    let(:c100_application) {
      instance_double(C100Application,
        children: [child],
        applicants: [],
        respondents: [],
        children_known_to_authorities: 'yes',
        children_known_to_authorities_details: 'details',
        children_protection_plan: 'no',
      )
    }

    let(:child) {
      instance_double(Child,
        full_name: 'name',
        dob: dob,
        dob_estimate: dob_estimate,
        gender: 'female',
        special_guardianship_order: special_guardianship_order,
        child_order: child_order,
        relationships: relationships,
      )
    }

    let(:dob) { Date.new(2018, 1, 20) }
    let(:dob_estimate) { nil }
    let(:special_guardianship_order) { nil }

    let(:child_order) { instance_double(ChildOrder, orders: ['an_order']) }
    let(:relationships) { double('relationships') }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_details)
      end
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      before do
        allow(relationships).to receive_message_chain(:where, :pluck).and_return(['mother'])
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(11)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq(:child_index_title)
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:child_full_name)
        expect(answers[1].value).to eq('name')

        expect(answers[2]).to be_an_instance_of(DateAnswer)
        expect(answers[2].question).to eq(:child_dob)
        expect(answers[2].value).to eq(Date.new(2018, 1, 20))

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:child_sex)
        expect(answers[3].value).to eq('female')

        expect(answers[4]).to be_an_instance_of(MultiAnswer)
        expect(answers[4].question).to eq(:child_applicants_relationship)
        expect(answers[4].value).to eq(['mother'])
        expect(c100_application).to have_received(:applicants)

        expect(answers[5]).to be_an_instance_of(MultiAnswer)
        expect(answers[5].question).to eq(:child_respondents_relationship)
        expect(answers[5].value).to eq(['mother'])
        expect(c100_application).to have_received(:respondents)

        expect(answers[6]).to be_an_instance_of(MultiAnswer)
        expect(answers[6].question).to eq(:child_orders)
        expect(answers[6].value).to eq(['other_issue'])

        expect(answers[7]).to be_an_instance_of(Partial)
        expect(answers[7].name).to eq(:row_blank_space)

        expect(answers[8]).to be_an_instance_of(Answer)
        expect(answers[8].question).to eq(:children_known_to_authorities)
        expect(c100_application).to have_received(:children_known_to_authorities)

        expect(answers[9]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[9].question).to eq(:children_known_to_authorities_details)
        expect(c100_application).to have_received(:children_known_to_authorities_details)

        expect(answers[10]).to be_an_instance_of(Answer)
        expect(answers[10].question).to eq(:children_protection_plan)
        expect(c100_application).to have_received(:children_protection_plan)
      end

      context 'when `dob` is nil' do
        let(:dob) { nil }
        let(:dob_estimate) { Date.today }

        it 'uses the dob estimate' do
          expect(answers[2]).to be_an_instance_of(DateAnswer)
          expect(answers[2].question).to eq(:child_dob_estimate)
          expect(answers[2].value).to eq(Date.today)
        end
      end

      context 'when the `special_guardianship_order` attribute is not `nil`' do
        let(:special_guardianship_order) { 'yes' }

        it 'shows the question-answer' do
          expect(answers[7]).to be_an_instance_of(Answer)
          expect(answers[7].question).to eq(:special_guardianship_order)
          expect(answers[7].value).to eq('yes')
        end
      end
    end
  end
end
