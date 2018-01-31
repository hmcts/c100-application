require 'spec_helper'

module Summary
  describe Sections::ApplicantsDetails do
    let(:c100_application) { instance_double(C100Application, applicants: [applicant]) }

    let(:applicant) {
      instance_double(Applicant,
        full_name: 'fullname',
        has_previous_name: has_previous_name,
        previous_name: previous_name,
        dob: Date.new(2018, 1, 20),
        gender: 'female',
        birthplace: 'birthplace',
        address: 'address',
        residence_requirement_met: 'yes',
        residence_history: 'history',
        home_phone: 'home_phone',
        mobile_phone: 'mobile_phone',
        email: 'email'
      )
    }

    subject { described_class.new(c100_application) }

    let(:has_previous_name) { 'no' }
    let(:previous_name) { nil }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:applicants_details) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#record_collection' do
      it {
        expect(c100_application).to receive(:applicants)
        subject.record_collection
      }
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(12)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq('applicants_details_index_title')
        expect(answers[0].i18n_opts).to eq({index: 1})

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:person_full_name)
        expect(answers[1].value).to eq('fullname')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:person_previous_name)
        expect(answers[2].value).to eq('no')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:person_sex)
        expect(answers[3].value).to eq('female')

        expect(answers[4]).to be_an_instance_of(DateAnswer)
        expect(answers[4].question).to eq(:person_dob)
        expect(answers[4].value).to eq(Date.new(2018, 1, 20))

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:person_birthplace)
        expect(answers[5].value).to eq('birthplace')

        expect(answers[6]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[6].question).to eq(:person_address)
        expect(answers[6].value).to eq('address')

        expect(answers[7]).to be_an_instance_of(Answer)
        expect(answers[7].question).to eq(:person_residence_requirement_met)
        expect(answers[7].value).to eq('yes')

        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:person_residence_history)
        expect(answers[8].value).to eq('history')

        expect(answers[9]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[9].question).to eq(:person_home_phone)
        expect(answers[9].value).to eq('home_phone')

        expect(answers[10]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[10].question).to eq(:person_mobile_phone)
        expect(answers[10].value).to eq('mobile_phone')

        expect(answers[11]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[11].question).to eq(:person_email)
        expect(answers[11].value).to eq('email')
      end

      context 'for existing previous name' do
        let(:has_previous_name) { 'yes' }
        let(:previous_name) { 'previous_name' }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(12)
        end

        it 'renders the previous name' do
          expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[2].question).to eq(:person_previous_name)
          expect(answers[2].value).to eq('previous_name')
        end
      end
    end
  end
end
