require 'spec_helper'

module Summary
  describe HtmlSections::OtherChildrenDetails do
    let(:c100_application) {
      instance_double(C100Application,
        other_children: [other_child],
      )
    }

    let(:other_child) {
      instance_double(OtherChild,
        to_param: 'uuid-123',
        full_name: 'name',
        dob: Date.new(2018, 1, 20),
        dob_estimate: nil,
        gender: 'female',
        special_guardianship_order: nil,
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:other_children_details)
      end
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(3)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq('other_children_details_index_title')
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:person_full_name)
        expect(answers[1].value).to eq('name')
        expect(answers[1].change_path).to eq('/steps/other_children/names/')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:person_personal_details)
        expect(answers[2].change_path).to eq('/steps/other_children/personal_details/uuid-123')
        expect(answers[2].answers.count).to eq(2)

          # personal_details group answers ###
          details = answers[2].answers

          expect(details[0]).to be_an_instance_of(DateAnswer)
          expect(details[0].question).to eq(:person_dob)
          expect(details[0].value).to eq(Date.new(2018, 1, 20))

          expect(details[1]).to be_an_instance_of(Answer)
          expect(details[1].question).to eq(:person_sex)
          expect(details[1].value).to eq('female')
      end
    end
  end
end
