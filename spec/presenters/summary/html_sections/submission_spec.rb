require 'spec_helper'

module Summary
  describe HtmlSections::Submission do
    let(:c100_application) {
      instance_double(
        C100Application,
        submission_type: 'online',
        receipt_email: 'test@example.com',
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:submission) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(AnswersGroup)
        expect(answers[0].name).to eq(:submission_type)
        expect(answers[0].change_path).to eq('/steps/application/submission')
      end

      context '`submission_type` answers group' do
        let(:group) { answers[0] }

        it 'has the right questions in the right order' do
          expect(group.answers.count).to eq(2)

          expect(group.answers[0]).to be_an_instance_of(Answer)
          expect(group.answers[0].question).to eq(:submission_type)
          expect(group.answers[0].value).to eq('online')

          expect(group.answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group.answers[1].question).to eq(:submission_receipt_email)
          expect(group.answers[1].value).to eq('test@example.com')
        end
      end
    end
  end
end
