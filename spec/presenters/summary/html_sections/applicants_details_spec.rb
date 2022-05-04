require 'spec_helper'

module Summary
  describe HtmlSections::ApplicantsDetails do
    let(:c100_application) {
      instance_double(
        C100Application,
        applicants: [applicant]
      )
    }

    let(:applicant) {
      instance_double(Applicant,
        to_param: 'uuid-123',
        full_name: 'Applicant Test',
        has_previous_name: has_previous_name,
        previous_name: previous_name,
        dob: Date.new(2018, 1, 20),
        dob_estimate: nil,
        gender: 'female',
        birthplace: 'birthplace',
        address_unknown: false, # for applicants this can only be `false`
        residence_requirement_met: 'yes',
        residence_keep_private: 'yes',
        residence_history: 'history',
        home_phone: 'home_phone',
        mobile_phone: 'mobile_phone',
        email_provided: 'yes',
        email: 'email',
        voicemail_consent: 'yes',
        email_keep_private: 'yes',
        phone_keep_private: 'yes',
        mobile_keep_private: 'yes',
        relationships: [relationship],
      )
    }

    before do
       allow(applicant).to receive(:full_address).and_return('full address')
       allow(relationship).to receive(:person).and_return(applicant)
    end

    subject { described_class.new(c100_application) }

    let(:has_previous_name) { 'no' }
    let(:previous_name) { nil }

    let(:relationship) {
      instance_double(
        Relationship,
        relation: 'mother',
        relation_other_value: nil,
        minor: child,
        parental_responsibility: nil,
      )
    }
    let(:child) { instance_double(Child, to_param: 'uuid-555', full_name: 'Child Test') }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:applicants_details) }
    end

    describe '#record_collection' do
      it {
        expect(c100_application).to receive(:applicants)
        subject.record_collection
      }
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(6)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq('applicants_details_index_title')
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:person_full_name)
        expect(answers[1].change_path).to eq('/steps/applicant/names/')
        expect(answers[1].value).to eq('Applicant Test')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:person_personal_details)
        expect(answers[2].change_path).to eq('/steps/applicant/personal_details/uuid-123')
        expect(answers[2].answers.count).to eq(4)

          # personal_details group answers ###
          details = answers[2].answers

          expect(details[0]).to be_an_instance_of(Answer)
          expect(details[0].question).to eq(:person_previous_name)
          expect(details[0].value).to eq('no')

          expect(details[1]).to be_an_instance_of(Answer)
          expect(details[1].question).to eq(:person_sex)
          expect(details[1].value).to eq('female')

          expect(details[2]).to be_an_instance_of(DateAnswer)
          expect(details[2].question).to eq(:person_dob)
          expect(details[2].value).to eq(Date.new(2018, 1, 20))

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:person_birthplace)
          expect(details[3].value).to eq('birthplace')

          expect(answers[3]).to be_an_instance_of(AnswersGroup)
          expect(answers[3].name).to eq(:person_address_details)
          expect(answers[3].change_path).to eq('/steps/applicant/address_details/uuid-123')

          expect(answers[3].answers.count).to eq(4)

          # personal_details group answers ###
          details = answers[3].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:person_address)
          expect(details[0].value).to eq('full address')

          expect(details[1]).to be_an_instance_of(Answer)
          expect(details[1].question).to eq(:person_residence_requirement_met)
          expect(details[1].value).to eq('yes')

          expect(details[2]).to be_an_instance_of(Answer)
          expect(details[2].question).to eq(:residence_keep_private)
          expect(details[2].value).to eq('yes')

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:person_residence_history)
          expect(details[3].value).to eq('history')


        expect(answers[4]).to be_an_instance_of(AnswersGroup)
        expect(answers[4].name).to eq(:person_contact_details)
        expect(answers[4].change_path).to eq('/steps/applicant/contact_details/uuid-123')
        expect(answers[4].answers.count).to eq(8)

          # contact details group answers ###
          details = answers[4].answers

          expect(details[0]).to be_an_instance_of(Answer)
          expect(details[0].question).to eq(:person_email_provided)
          expect(details[0].value).to eq('yes')

          expect(details[1]).to be_an_instance_of(FreeTextAnswer)
          expect(details[1].question).to eq(:person_email)
          expect(details[1].value).to eq('email')

          expect(details[2]).to be_an_instance_of(Answer)
          expect(details[2].question).to eq(:email_keep_private)
          expect(details[2].value).to eq('yes')

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:person_home_phone)
          expect(details[3].value).to eq('home_phone')

          expect(details[4]).to be_an_instance_of(Answer)
          expect(details[4].question).to eq(:phone_keep_private)
          expect(details[4].value).to eq('yes')

          expect(details[5]).to be_an_instance_of(FreeTextAnswer)
          expect(details[5].question).to eq(:person_mobile_phone)
          expect(details[5].value).to eq('mobile_phone')

          expect(details[6]).to be_an_instance_of(Answer)
          expect(details[6].question).to eq(:mobile_keep_private)
          expect(details[6].value).to eq('yes')

          expect(details[7]).to be_an_instance_of(Answer)
          expect(details[7].question).to eq(:person_voicemail_consent)
          expect(details[7].value).to eq('yes')

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:relationship_to_child)
        expect(answers[5].change_path).to eq('/steps/applicant/relationship/uuid-123/child/uuid-555')
        expect(answers[5].value).to eq('mother')
        expect(answers[5].i18n_opts).to eq({child_name: 'Child Test'})
      end

      context 'for existing previous name' do
        let(:has_previous_name) { 'yes' }
        let(:previous_name) { 'previous_name' }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(6)
        end

        it 'renders the previous name' do
          expect(answers[2]).to be_an_instance_of(AnswersGroup)

          details = answers[2].answers
          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:person_previous_name)
          expect(details[0].value).to eq('previous_name')
        end
      end

      context 'for `other` children relationship' do
        let(:relationship) {
          instance_double(
            Relationship,
            relation: 'other',
            relation_other_value: 'Aunt',
            minor: child,
            parental_responsibility: nil,
          )
        }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(6)
        end

        it 'renders the correct relationship value' do
          expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[5].question).to eq(:relationship_to_child)
          expect(answers[5].change_path).to eq('/steps/applicant/relationship/uuid-123/child/uuid-555')
          expect(answers[5].value).to eq('Aunt')
          expect(answers[5].i18n_opts).to eq({child_name: 'Child Test'})
        end
      end

      context 'for a children relationship with permission questions answered' do
        let(:relationship) {
          instance_double(Relationship,
            to_param: 'uuid-123',
            relation: 'other',
            relation_other_value: 'Aunt',
            minor: child,
            parental_responsibility: 'no',
            living_order: 'yes',
            # nil values will not show
            amendment: nil,
            time_order: nil,
            living_arrangement: nil,
            consent: nil,
            family: nil,
            local_authority: nil,
            relative: nil,
          )
        }

        before do
          allow(relationship).to receive(:person).and_return(applicant)
        end

        it 'has the correct number of rows' do
          expect(answers.count).to eq(8)
        end

        it 'renders the correct permission values' do
          expect(answers[6]).to be_an_instance_of(Answer)
          expect(answers[6].question).to eq('child_permission_parental_responsibility')
          expect(answers[6].change_path).to eq('/steps/permission/parental_responsibility/relationship/uuid-123')
          expect(answers[6].value).to eq('no')
          expect(answers[6].i18n_opts).to eq({ applicant_name: 'Applicant Test', child_name: 'Child Test'})

          expect(answers[7]).to be_an_instance_of(Answer)
          expect(answers[7].question).to eq('child_permission_living_order')
          expect(answers[7].change_path).to eq('/steps/permission/living_order/relationship/uuid-123')
          expect(answers[7].value).to eq('yes')
          expect(answers[7].i18n_opts).to eq({ applicant_name: 'Applicant Test', child_name: 'Child Test'})
        end
      end
    end
  end
end
