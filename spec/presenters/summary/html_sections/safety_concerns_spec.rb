require 'spec_helper'

module Summary
  describe HtmlSections::SafetyConcerns do
    let(:c100_application) {
      instance_double(C100Application,
        address_confidentiality: 'yes',
        risk_of_abduction: 'no',
        substance_abuse: 'yes',
        substance_abuse_details: 'substance details',
        children_abuse: 'no',
        domestic_abuse: 'no',
        other_abuse: 'no',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:safety_concerns) }
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(6)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:address_confidentiality)
        expect(answers[0].change_path).to eq('/steps/safety_questions/address_confidentiality')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:risk_of_abduction)
        expect(answers[1].change_path).to eq('/steps/safety_questions/risk_of_abduction')
        expect(answers[1].value).to eq('no')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:substance_abuse)
        expect(answers[2].change_path).to eq('/steps/safety_questions/substance_abuse')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:children_abuse)
        expect(answers[3].change_path).to eq('/steps/safety_questions/children_abuse')
        expect(answers[3].value).to eq('no')

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:domestic_abuse)
        expect(answers[4].change_path).to eq('/steps/safety_questions/domestic_abuse')
        expect(answers[4].value).to eq('no')

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:other_abuse)
        expect(answers[5].change_path).to eq('/steps/safety_questions/other_abuse')
        expect(answers[5].value).to eq('no')
      end

      context 'substance abuse' do
        let(:group_answers) { answers[2].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:substance_abuse)
          expect(group_answers[0].value).to eq('yes')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:substance_abuse_details)
          expect(group_answers[1].value).to eq('substance details')
        end
      end
    end
  end
end
