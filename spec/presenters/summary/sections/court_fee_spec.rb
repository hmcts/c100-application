require 'spec_helper'

module Summary
  describe Sections::CourtFee do
    let(:c100_application) {
      instance_double(
        C100Application,
        payment_type: payment_type,
        hwf_reference_number: hwf_reference_number,
        solicitor_account_number: solicitor_account_number,
      )
    }

    let(:payment_type) { 'whatever' }
    let(:hwf_reference_number) { nil }
    let(:solicitor_account_number) { nil }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:court_fee)
      end
    end

    describe '#answers' do
      context 'self payment' do
        it 'has the correct rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:payment_type)
          expect(answers[0].value).to eq('whatever')
        end
      end

      context 'help with fees payment' do
        let(:hwf_reference_number) { '12345' }

        it 'has the correct rows' do
          expect(answers.count).to eq(2)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:payment_type)
          expect(answers[0].value).to eq('whatever')

          expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[1].question).to eq(:hwf_reference_number)
          expect(answers[1].value).to eq('12345')
        end
      end

      context 'solicitor payment' do
        let(:solicitor_account_number) { '12345' }

        it 'has the correct rows' do
          expect(answers.count).to eq(2)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:payment_type)
          expect(answers[0].value).to eq('whatever')

          expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[1].question).to eq(:solicitor_account_number)
          expect(answers[1].value).to eq('12345')
        end
      end
    end
  end
end
