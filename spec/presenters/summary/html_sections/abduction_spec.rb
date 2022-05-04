require 'spec_helper'

module Summary
  describe HtmlSections::Abduction do
    let(:c100_application) { instance_double(C100Application, abduction_detail: abduction_detail) }

    subject { described_class.new(c100_application) }

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

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:abduction) }
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(6)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:abduction_passport_office_notified)
        expect(answers[0].change_path).to eq('/steps/abduction/international')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:abduction_children_have_passport)
        expect(answers[1].change_path).to eq('/steps/abduction/children_have_passport')
        expect(answers[1].value).to eq('yes')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:abduction_passport_possession)
        expect(answers[2].change_path).to eq('/steps/abduction/passport_details')
        expect(answers[2].answers.count).to eq(3)

          ## abduction_passport_possession group answers ###
          passport = answers[2].answers

          expect(passport[0]).to be_an_instance_of(Answer)
          expect(passport[0].question).to eq(:abduction_children_multiple_passports)
          expect(passport[0].value).to eq('yes')

          expect(passport[1]).to be_an_instance_of(MultiAnswer)
          expect(passport[1].question).to eq(:abduction_passport_possession)
          expect(passport[1].value).to eq(%w(mother other))

          expect(passport[2]).to be_an_instance_of(FreeTextAnswer)
          expect(passport[2].question).to eq(:abduction_passport_possession_other)
          expect(passport[2].value).to eq('friend')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:abduction_previous_attempt)
        expect(answers[3].change_path).to eq('/steps/abduction/previous_attempt')
        expect(answers[3].value).to eq('yes')

        expect(answers[4]).to be_an_instance_of(AnswersGroup)
        expect(answers[4].name).to eq(:abduction_previous_attempt)
        expect(answers[4].change_path).to eq('/steps/abduction/previous_attempt_details')
        expect(answers[4].answers.count).to eq(3)

          ## abduction_previous_attempt group answers ###
          attempt = answers[4].answers

          expect(attempt[0]).to be_an_instance_of(FreeTextAnswer)
          expect(attempt[0].question).to eq(:abduction_previous_attempt_details)
          expect(attempt[0].value).to eq('previous_attempt_details')

          expect(attempt[1]).to be_an_instance_of(Answer)
          expect(attempt[1].question).to eq(:abduction_previous_attempt_agency_involved)
          expect(attempt[1].value).to eq('yes')

          expect(attempt[2]).to be_an_instance_of(FreeTextAnswer)
          expect(attempt[2].question).to eq(:abduction_previous_attempt_agency_details)
          expect(attempt[2].value).to eq('previous_attempt_agency_details')

        expect(answers[5]).to be_an_instance_of(AnswersGroup)
        expect(answers[5].name).to eq(:abduction_risk_details)
        expect(answers[5].change_path).to eq('/steps/abduction/risk_details')
        expect(answers[5].answers.count).to eq(2)

          ## abduction_previous_attempt group answers ###
          risk = answers[5].answers

          expect(risk[0]).to be_an_instance_of(FreeTextAnswer)
          expect(risk[0].question).to eq(:abduction_risk_details)
          expect(risk[0].value).to eq('details')

          expect(risk[1]).to be_an_instance_of(FreeTextAnswer)
          expect(risk[1].question).to eq(:abduction_current_location)
          expect(risk[1].value).to eq('location')
      end
    end
  end
end
