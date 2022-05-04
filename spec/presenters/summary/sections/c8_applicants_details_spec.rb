require 'spec_helper'

module Summary
  describe Sections::C8ApplicantsDetails do
    let(:c100_application) {
      instance_double(
        C100Application,
        applicants: [applicant],
        address_confidentiality: 'yes'
      )
    }

    let(:applicant) {
      instance_double(Applicant,
        full_name: 'fullname',
        residence_history: 'history',
        home_phone: 'home_phone',
        mobile_phone: 'mobile_phone',
        email: 'email',
        voicemail_consent: 'yes',
        residence_keep_private: 'yes',
        email_keep_private: 'yes',
        phone_keep_private: 'yes',
        mobile_keep_private: 'yes'
      )
    }

    before do
      allow(applicant).to receive(:full_address).and_return('full address')
    end

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c8_applicants_details) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(true) }
    end

    describe '#record_collection' do
      it {
        expect(c100_application).to receive(:applicants)
        subject.record_collection
      }
    end

    describe '#bypass_relationships_c8?' do
      it { expect(subject.bypass_relationships_c8?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(10)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq('c8_applicants_details_index_title')
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:person_full_name)
        expect(answers[1].value).to eq('fullname')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:person_address)
        expect(answers[2].value).to eq('full address')

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:person_email)
        expect(answers[3].value).to eq('email')

        expect(answers[4]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[4].question).to eq(:person_home_phone)
        expect(answers[4].value).to eq('home_phone')

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:person_mobile_phone)
        expect(answers[5].value).to eq('mobile_phone')

        expect(answers[6]).to be_an_instance_of(Answer)
        expect(answers[6].question).to eq(:person_voicemail_consent)
        expect(answers[6].value).to eq('yes')

        expect(answers[7]).to be_an_instance_of(Partial)
        expect(answers[7].name).to eq(:row_blank_space)

        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:person_residence_history)
        expect(answers[8].value).to eq('history')

        expect(answers[9]).to be_an_instance_of(Partial)
        expect(answers[9].name).to eq(:row_blank_space)
      end

      context 'only one marked as private' do
        let(:applicant) {
          instance_double(Applicant,
            full_name: 'fullname',
            residence_history: 'history',
            home_phone: 'home_phone',
            mobile_phone: 'mobile_phone',
            email: 'email',
            voicemail_consent: 'yes',
            residence_keep_private: 'no',
            email_keep_private: 'no',
            phone_keep_private: 'no',
            mobile_keep_private: 'no'
          )
        }
        it 'has the correct number of rows' do
          expect(answers.count).to eq(5)
        end

      end
    end
  end
end
