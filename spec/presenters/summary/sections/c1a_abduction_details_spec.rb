require 'spec_helper'

module Summary
  describe Sections::C1aAbductionDetails do
    let(:c100_application) {
      instance_double(
        C100Application,
        risk_of_abduction: risk_of_abduction,
        abduction_detail: abduction_detail
    ) }

    let(:risk_of_abduction) { 'yes' }

    let(:abduction_detail) {
      AbductionDetail.new(
        passport_office_notified: 'yes',
        children_have_passport: 'yes',
        children_multiple_passports: 'yes',
        passport_possession: %w(mother other),
        passport_possession_other_details: 'friend',
        previous_attempt: 'yes',
        previous_attempt_details: 'previous_attempt_details',
        previous_attempt_agency_involved: 'yes',
        previous_attempt_agency_details: 'previous_attempt_agency_details',
        risk_details: 'details',
        current_location: 'location',
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c1a_abduction_details) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(11)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_abduction_risk)
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:c1a_abduction_details)
        expect(answers[1].value).to eq('details')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:c1a_abduction_previous_attempt)
        expect(answers[2].value).to eq('yes')

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:c1a_abduction_previous_attempt_details)
        expect(answers[3].value).to eq('previous_attempt_details')

        expect(answers[4]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[4].question).to eq(:c1a_abduction_children_current_location)
        expect(answers[4].value).to eq('location')

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:c1a_abduction_passport_office_notified)
        expect(answers[5].value).to eq('yes')

        expect(answers[6]).to be_an_instance_of(Answer)
        expect(answers[6].question).to eq(:c1a_abduction_children_multiple_passports)
        expect(answers[6].value).to eq('yes')

        expect(answers[7]).to be_an_instance_of(MultiAnswer)
        expect(answers[7].question).to eq(:c1a_abduction_passport_possession)
        expect(answers[7].value).to eq(%w(mother other))

        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:c1a_abduction_passport_possession_other)
        expect(answers[8].value).to eq('friend')

        expect(answers[9]).to be_an_instance_of(Answer)
        expect(answers[9].question).to eq(:c1a_abduction_previous_attempt_agency_involved)
        expect(answers[9].value).to eq('yes')

        expect(answers[10]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[10].question).to eq(:c1a_abduction_previous_attempt_agency_details)
        expect(answers[10].value).to eq('previous_attempt_agency_details')
      end

      context 'when there is no abduction risk' do
        let(:risk_of_abduction) { 'no' }
        let(:abduction_detail) { nil }

        it 'has the correct rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:c1a_abduction_risk)
          expect(answers[0].value).to eq('no')
        end
      end

      context 'when there are no abduction details' do
        let(:risk_of_abduction) { 'yes' }
        let(:abduction_detail) { nil }

        it 'has the correct rows' do
          expect(answers.count).to eq(1)

          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:c1a_abduction_risk)
          expect(answers[0].value).to eq('yes')
        end
      end
    end
  end
end
