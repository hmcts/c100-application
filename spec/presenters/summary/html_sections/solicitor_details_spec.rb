require 'spec_helper'

module Summary
  describe HtmlSections::SolicitorDetails do
    let(:has_solicitor){'Yes'}
    let(:c100_application) {
      instance_double(C100Application,
        has_solicitor: has_solicitor,
        solicitor: solicitor,
      )
    }

    let(:solicitor) {
      instance_double(Solicitor,
        to_param: 'uuid-123',
        full_name: 'name',
        firm_name: 'firm',
        reference: 'ref',
        full_address: '22 acacia avenue',
        email: 'solicitor@example.com',
        phone_number: '0123456789',
        fax_number: '0987654321',
        dx_number: 'dx012345',
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:solicitor_details)
      end
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(4)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:has_solicitor)
        expect(answers[0].value).to eq(has_solicitor)
        expect(answers[0].change_path).to eq('/steps/applicant/has_solicitor')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:solicitor_personal_details)
        expect(answers[1].change_path).to eq('/steps/solicitor/personal_details')
        expect(answers[1].answers.count).to eq(3)

          # personal_details group answers ###
          details = answers[1].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:solicitor_full_name)
          expect(details[0].value).to eq('name')

          expect(details[1]).to be_an_instance_of(FreeTextAnswer)
          expect(details[1].question).to eq(:solicitor_firm_name)
          expect(details[1].value).to eq('firm')

          expect(details[2]).to be_an_instance_of(FreeTextAnswer)
          expect(details[2].question).to eq(:solicitor_reference)
          expect(details[2].value).to eq('ref')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:solicitor_address_details)
        expect(answers[2].change_path).to eq('/steps/solicitor/address_details')
        expect(answers[2].answers.count).to eq(1)

          # address_details group answers ###
          details = answers[2].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:solicitor_address)
          expect(details[0].value).to eq('22 acacia avenue')

        expect(answers[3]).to be_an_instance_of(AnswersGroup)
        expect(answers[3].name).to eq(:solicitor_contact_details)
        expect(answers[3].change_path).to eq('/steps/solicitor/contact_details')
        expect(answers[3].answers.count).to eq(4)

          # contact_details group answers ###
          details = answers[3].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:solicitor_email)
          expect(details[0].value).to eq('solicitor@example.com')

          expect(details[1]).to be_an_instance_of(FreeTextAnswer)
          expect(details[1].question).to eq(:solicitor_phone_number)
          expect(details[1].value).to eq('0123456789')

          expect(details[2]).to be_an_instance_of(FreeTextAnswer)
          expect(details[2].question).to eq(:solicitor_fax_number)
          expect(details[2].value).to eq('0987654321')

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:solicitor_dx_number)
          expect(details[3].value).to eq('dx012345')
      end
    end
  end
end
