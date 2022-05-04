require 'spec_helper'

module Summary
  describe HtmlSections::Payment do
    let(:c100_application) {
      instance_double(
        C100Application,
        payment_type: 'help_with_fees',
        hwf_reference_number: '123-XYZ',
        solicitor_account_number: nil,
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:payment) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(1)

        expect(answers[0]).to be_an_instance_of(AnswersGroup)
        expect(answers[0].name).to eq(:payment_type)
        expect(answers[0].change_path).to eq('/steps/application/payment')
      end

      context '`payment_type` answers group' do
        let(:group) { answers[0] }

        it 'has the right questions in the right order' do
          expect(group.answers.count).to eq(2)

          expect(group.answers[0]).to be_an_instance_of(Answer)
          expect(group.answers[0].question).to eq(:payment_type)
          expect(group.answers[0].value).to eq('help_with_fees')

          expect(group.answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group.answers[1].question).to eq(:hwf_reference_number)
          expect(group.answers[1].value).to eq('123-XYZ')
        end
      end

      context 'when user is paying' do
        let(:c100_application) {
          instance_double(
            C100Application,
            payment_type: 'self_payment_card',
            hwf_reference_number: nil,
            solicitor_account_number: nil,
          )
        }

        let(:group) { answers[0] }

        it 'has the right questions in the right order' do
          expect(group.answers.count).to eq(1)

          expect(group.answers[0]).to be_an_instance_of(Answer)
          expect(group.answers[0].question).to eq(:payment_type)
          expect(group.answers[0].value).to eq('self_payment_card')
        end
      end
    end
  end
end
