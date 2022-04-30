require 'spec_helper'

module Summary
  describe Sections::SolicitorDetails do
    let(:c100_application) {
      instance_double(
        C100Application,
        solicitor_account_number: solicitor_account_number,
        has_solicitor: 'yes',
        solicitor: solicitor,
    ) }

    subject { described_class.new(c100_application) }

    let(:solicitor) {
      instance_double(
        Solicitor,
        full_name: 'full_name',
        firm_name: 'firm_name',
        reference: 'reference',
        full_address: 'address',
        email: 'email',
        phone_number: 'phone_number',
        fax_number: 'fax_number',
        dx_number: 'dx_number',
    ) }
    let(:solicitor_account_number) { '12345' }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:solicitor_details) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      context 'no solicitor details' do
        let(:solicitor) { nil }

        it 'has the correct rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:has_solicitor)
          expect(answers[0].value).to eq(GenericYesNo::NO)
        end
      end

      context 'no solicitor solicitor_fee_account' do
        let(:solicitor_account_number) { nil }

        it 'has the correct rows' do
          expect(answers.count).to eq(10)

          expect(answers[9]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[9].question).to eq(:solicitor_fee_account)
          expect(answers[9].show?).to eq(true)
          expect(answers[9].value).to be_nil
        end
      end

      context 'solicitor details are present' do
        it 'has the correct rows' do
          expect(answers.count).to eq(10)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:has_solicitor)
          expect(answers[0].value).to eq(GenericYesNo::YES)

          expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[1].question).to eq(:solicitor_full_name)
          expect(answers[1].value).to eq('full_name')

          expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[2].question).to eq(:solicitor_firm_name)
          expect(answers[2].value).to eq('firm_name')

          expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[3].question).to eq(:solicitor_address)
          expect(answers[3].value).to eq('address')

          expect(answers[4]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[4].question).to eq(:solicitor_email)
          expect(answers[4].value).to eq('email')

          expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[5].question).to eq(:solicitor_phone_number)
          expect(answers[5].value).to eq('phone_number')

          expect(answers[6]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[6].question).to eq(:solicitor_fax_number)
          expect(answers[6].value).to eq('fax_number')

          expect(answers[7]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[7].question).to eq(:solicitor_dx_number)
          expect(answers[7].value).to eq('dx_number')

          expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[8].question).to eq(:solicitor_reference)
          expect(answers[8].value).to eq('reference')

          expect(answers[9]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[9].question).to eq(:solicitor_fee_account)
          expect(answers[9].value).to eq('12345')
        end
      end
    end
  end
end
