require 'spec_helper'

module Summary
  describe Sections::RespondentsDetails do
    let(:c100_application) { instance_double(C100Application, respondents: [respondent]) }

    let(:respondent) {
      instance_double(Respondent,
        full_name: 'fullname',
        has_previous_name: has_previous_name,
        previous_name: previous_name,
        dob: dob,
        dob_estimate: dob_estimate,
        gender: 'female',
        birthplace: 'birthplace',
        residence_requirement_met: 'yes',
        residence_keep_private: 'yes',
        residence_history: 'history',
        home_phone: 'home_phone',
        mobile_phone: 'mobile_phone',
        email: 'email',
        email_keep_private: 'yes',
        phone_keep_private: 'yes',
        mobile_keep_private: 'yes',
        voicemail_consent: nil,
      )
    }

    before do
      allow(respondent).to receive(:full_address).and_return('full address')
    end


    subject { described_class.new(c100_application) }

    let(:has_previous_name) { 'no' }
    let(:previous_name) { nil }
    let(:dob) { Date.new(2018, 1, 20) }
    let(:dob_estimate) { nil }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:respondents_details) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#record_collection' do
      it {
        expect(c100_application).to receive(:respondents)
        subject.record_collection
      }

      it {
        expect(subject.record_collection).not_to be_an_instance_of(C8CollectionProxy)
      }
    end

    describe '#bypass_relationships_c8?' do
      it { expect(subject.bypass_relationships_c8?).to eq(false) }
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      before do
        allow_any_instance_of(
          RelationshipsPresenter
        ).to receive(:relationship_to_children).with(
          respondent, show_person_name: false, bypass_c8: false
        ).and_return('relationships')
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(18)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Separator)
        expect(answers[0].title).to eq('respondents_details_index_title')
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
        expect(answers[6].value).to eq('full address')

        expect(answers[7]).to be_an_instance_of(Answer)
        expect(answers[7].question).to eq(:person_residence_requirement_met)
        expect(answers[7].value).to eq('yes')

        expect(answers[8]).to be_an_instance_of(Answer)
        expect(answers[8].question).to eq(:residence_keep_private)
        expect(answers[8].value).to eq('yes')

        expect(answers[9]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[9].question).to eq(:person_residence_history)
        expect(answers[9].value).to eq('history')

        expect(answers[10]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[10].question).to eq(:person_email)
        expect(answers[10].value).to eq('email')

        expect(answers[11]).to be_an_instance_of(Answer)
        expect(answers[11].question).to eq(:email_keep_private)
        expect(answers[11].value).to eq('yes')

        expect(answers[12]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[12].question).to eq(:person_home_phone)
        expect(answers[12].value).to eq('home_phone')

        expect(answers[13]).to be_an_instance_of(Answer)
        expect(answers[13].question).to eq(:phone_keep_private)
        expect(answers[13].value).to eq('yes')

        expect(answers[14]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[14].question).to eq(:person_mobile_phone)
        expect(answers[14].value).to eq('mobile_phone')

        expect(answers[15]).to be_an_instance_of(Answer)
        expect(answers[15].question).to eq(:mobile_keep_private)
        expect(answers[15].value).to eq('yes')

        expect(answers[16]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[16].question).to eq(:person_relationship_to_children)
        expect(answers[16].value).to eq('relationships')

        expect(answers[17]).to be_an_instance_of(Partial)
        expect(answers[17].name).to eq(:row_blank_space)
      end

      context 'for existing previous name' do
        let(:has_previous_name) { 'yes' }
        let(:previous_name) { 'previous_name' }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(18)
        end

        it 'renders the previous name' do
          expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[2].question).to eq(:person_previous_name)
          expect(answers[2].value).to eq('previous_name')
        end
      end

      context 'when `dob` is nil' do
        let(:dob) { nil }
        let(:dob_estimate) { Date.today }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(18)
        end

        it 'uses the dob estimate' do
          expect(answers[4]).to be_an_instance_of(DateAnswer)
          expect(answers[4].question).to eq(:person_dob_estimate)
          expect(answers[4].value).to eq(Date.today)
        end
      end

      context 'when `dob` and `age estimate` are both nil' do
        let(:dob) { nil }
        let(:dob_estimate) { nil }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(18)
        end

        it 'provides a nil dob' do
          expect(answers[4]).to be_an_instance_of(DateAnswer)
          expect(answers[4].question).to eq(:person_dob)
          expect(answers[4].value).to eq(nil)
        end
      end
    end
  end
end
