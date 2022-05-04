require 'spec_helper'

module Summary
  describe HtmlSections::AttendingCourtV2 do
    subject { described_class.new(c100_application) }

    let(:c100_application) { instance_double(C100Application, court_arrangement: court_arrangement) }

    let(:court_arrangement) {
      instance_double(CourtArrangement,
        intermediary_help: 'yes',
        intermediary_help_details: 'intermediary_help_details',
        language_options: language_options,
        language_interpreter_details: 'language_interpreter_details',
        sign_language_interpreter_details: 'sign_language_interpreter_details',
        welsh_language_details: 'welsh_language_details',
        special_arrangements: special_arrangements,
        special_arrangements_details: special_arrangements_details,
        special_assistance: special_assistance,
        special_assistance_details: special_assistance_details,
    )}

    let(:language_options) { %w(language_interpreter sign_language_interpreter welsh_language) }
    let(:special_arrangements) { ['video_link'] }
    let(:special_arrangements_details) { 'special_arrangements_details' }
    let(:special_assistance) { ['hearing_loop'] }
    let(:special_assistance_details) { 'special_assistance_details' }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:attending_court) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(AnswersGroup)
        expect(answers[0].name).to eq(:intermediary)
        expect(answers[0].change_path).to eq('/steps/attending_court/intermediary')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:language_interpreter)
        expect(answers[1].change_path).to eq('/steps/attending_court/language')

        expect(answers[2]).to be_an_instance_of(AnswersGroup)
        expect(answers[2].name).to eq(:special_arrangements)
        expect(answers[2].change_path).to eq('/steps/attending_court/special_arrangements')

        expect(answers[3]).to be_an_instance_of(AnswersGroup)
        expect(answers[3].name).to eq(:special_assistance)
        expect(answers[3].change_path).to eq('/steps/attending_court/special_assistance')
      end

      context 'when the language step has not been visited yet' do
        let(:language_options) { nil }

        it 'does not show the block' do
          expect(answers.count).to eq(3)
        end
      end

      context 'when the special arrangements step has not been visited yet' do
        let(:special_arrangements) { nil }

        it 'does not show the block' do
          expect(answers.count).to eq(3)
        end
      end

      context 'when the special assistance step has not been visited yet' do
        let(:special_assistance) { nil }

        it 'does not show the block' do
          expect(answers.count).to eq(3)
        end
      end

      context 'intermediary' do
        let(:group_answers) { answers[0].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:intermediary_help)
          expect(group_answers[0].value).to eq('yes')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:intermediary_help_details)
          expect(group_answers[1].value).to eq('intermediary_help_details')
        end
      end

      context 'language_interpreter' do
        let(:group_answers) { answers[1].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(6)

          expect(group_answers[0]).to be_an_instance_of(Answer)
          expect(group_answers[0].question).to eq(:language_interpreter)
          expect(group_answers[0].value).to eq('true')

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:language_interpreter_details)
          expect(group_answers[1].value).to eq('language_interpreter_details')

          expect(group_answers[2]).to be_an_instance_of(Answer)
          expect(group_answers[2].question).to eq(:sign_language_interpreter)
          expect(group_answers[2].value).to eq('true')

          expect(group_answers[3]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[3].question).to eq(:sign_language_interpreter_details)
          expect(group_answers[3].value).to eq('sign_language_interpreter_details')

          expect(group_answers[4]).to be_an_instance_of(Answer)
          expect(group_answers[4].question).to eq(:welsh_language)
          expect(group_answers[4].value).to eq('true')

          expect(group_answers[5]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[5].question).to eq(:welsh_language_details)
          expect(group_answers[5].value).to eq('welsh_language_details')
        end

        context 'when no check boxes were selected' do
          let(:language_options) { [] }

          it 'still shows the block because we convert booleans to strings' do
            expect(group_answers.count).to eq(6)

            expect(group_answers[0]).to be_an_instance_of(Answer)
            expect(group_answers[0].question).to eq(:language_interpreter)
            expect(group_answers[0].value).to eq('false')

            expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
            expect(group_answers[1].question).to eq(:language_interpreter_details)
            expect(group_answers[1].value).to eq('language_interpreter_details')

            expect(group_answers[2]).to be_an_instance_of(Answer)
            expect(group_answers[2].question).to eq(:sign_language_interpreter)
            expect(group_answers[2].value).to eq('false')

            expect(group_answers[3]).to be_an_instance_of(FreeTextAnswer)
            expect(group_answers[3].question).to eq(:sign_language_interpreter_details)
            expect(group_answers[3].value).to eq('sign_language_interpreter_details')

            expect(group_answers[4]).to be_an_instance_of(Answer)
            expect(group_answers[4].question).to eq(:welsh_language)
            expect(group_answers[4].value).to eq('false')

            expect(group_answers[5]).to be_an_instance_of(FreeTextAnswer)
            expect(group_answers[5].question).to eq(:welsh_language_details)
            expect(group_answers[5].value).to eq('welsh_language_details')
          end
        end
      end

      context 'special_arrangements' do
        let(:group_answers) { answers[2].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
          expect(group_answers[0].question).to eq(:special_arrangements)
          expect(group_answers[0].value).to eq(['video_link'])

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:special_arrangements_details)
          expect(group_answers[1].value).to eq('special_arrangements_details')
        end

        context 'when no check boxes were selected' do
          let(:special_arrangements) { [] }

          it 'still shows the block because `show: true` (will use the `absence_answer`)' do
            expect(group_answers.count).to eq(2)

            expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
            expect(group_answers[0].question).to eq(:special_arrangements)
            expect(group_answers[0].value).to eq([])
          end
        end
      end

      context 'special_assistance' do
        let(:group_answers) { answers[3].answers }

        it 'has the correct rows in the right order' do
          expect(group_answers.count).to eq(2)

          expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
          expect(group_answers[0].question).to eq(:special_assistance)
          expect(group_answers[0].value).to eq(['hearing_loop'])

          expect(group_answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(group_answers[1].question).to eq(:special_assistance_details)
          expect(group_answers[1].value).to eq('special_assistance_details')
        end

        context 'when no check boxes were selected' do
          let(:special_assistance) { [] }

          it 'still shows the block because `show: true` (will use the `absence_answer`)' do
            expect(group_answers.count).to eq(2)

            expect(group_answers[0]).to be_an_instance_of(MultiAnswer)
            expect(group_answers[0].question).to eq(:special_assistance)
            expect(group_answers[0].value).to eq([])
          end
        end
      end
    end
  end
end
