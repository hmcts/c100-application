require 'spec_helper'

module Summary
  describe HtmlSections::LitigationCapacity do
    let(:c100_application) {
      instance_double(C100Application,
        reduced_litigation_capacity: 'yes',
        participation_capacity_details: 'participation_capacity_details',
        participation_other_factors_details: 'participation_other_factors_details',
        participation_referral_or_assessment_details: 'participation_referral_or_assessment_details',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:litigation_capacity) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:reduced_litigation_capacity)
        expect(answers[0].value).to eq('yes')
        expect(answers[0].change_path).to eq('/steps/application/litigation_capacity')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:litigation_capacity)
        expect(answers[1].change_path).to eq('/steps/application/litigation_capacity_details')
      end

      context 'litigation_capacity' do
        let(:group_answers) { answers[1].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(3)

          expect(group_answers[0]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[0].question).to eq(:participation_capacity_details)
          expect(group_answers[0].value).to eq('participation_capacity_details')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:participation_other_factors_details)
          expect(group_answers[1].value).to eq('participation_other_factors_details')

          expect(group_answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[2].question).to eq(:participation_referral_or_assessment_details)
          expect(group_answers[2].value).to eq('participation_referral_or_assessment_details')
        end
      end
    end
  end
end
