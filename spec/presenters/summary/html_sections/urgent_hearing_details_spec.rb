require 'spec_helper'

module Summary
  describe HtmlSections::UrgentHearingDetails do
    let(:c100_application) {
      instance_double(C100Application,
        given_answers
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    let(:urgent_hearing_requested) {
      {
        urgent_hearing: 'yes',
        urgent_hearing_details: 'details',
        urgent_hearing_when: 'when',
        urgent_hearing_short_notice: 'yes',
        urgent_hearing_short_notice_details: 'short notice details',
      }
    }
    let(:urgent_hearing_not_requested) {
      {
        urgent_hearing: 'no',
        urgent_hearing_details: nil,
        urgent_hearing_when: nil,
        urgent_hearing_short_notice: nil,
        urgent_hearing_short_notice_details: nil,
      }
    }
    let(:given_answers) { urgent_hearing_requested }

    describe '#name' do
      it { expect(subject.name).to eq(:urgent_hearing) }
    end

    describe '#answers' do
      describe 'the first row' do
        let(:row){ answers[0] }

        it 'is an Answer' do
          expect(row).to be_an_instance_of(Answer)
        end

        it 'has the correct question' do
          expect(row.question).to eq(:urgent_hearing)
        end

        it 'has the correct change_path' do
          expect(row.change_path).to eq('/steps/application/urgent_hearing')
        end
      end

      context 'when the user has not asked for a without notice hearing' do
        let(:given_answers) { urgent_hearing_not_requested }

        it 'has only one row' do
          expect(answers.count).to eq(1)
        end
      end

      context 'when the user has asked for a without notice hearing' do
        let(:given_answers) { urgent_hearing_requested }

        it 'has two rows' do
          expect(answers.count).to eq(2)
        end

        describe 'the second row' do
          let(:row){ answers[1] }

          it 'is an AnswersGroup' do
            expect(row).to be_an_instance_of(AnswersGroup)
          end

          it 'has the correct name' do
            expect(row.name).to eq(:urgent_hearing_details)
          end

          it 'has the correct change_path' do
            expect(row.change_path).to eq('/steps/application/urgent_hearing_details')
          end

          describe 'the grouped answers' do
            let(:grouped_answers){ row.answers }

            it 'has the right number of answers' do
              expect(grouped_answers.count).to eq(4)
            end

            it 'has the right rows' do
              expect(grouped_answers[0]).to be_an_instance_of(FreeTextAnswer)
              expect(grouped_answers[0].question).to eq(:urgent_hearing_details)
              expect(grouped_answers[0].value).to eq('details')

              expect(grouped_answers[1]).to be_an_instance_of(FreeTextAnswer)
              expect(grouped_answers[1].question).to eq(:urgent_hearing_when)
              expect(grouped_answers[1].value).to eq('when')

              expect(grouped_answers[2]).to be_an_instance_of(Answer)
              expect(grouped_answers[2].question).to eq(:urgent_hearing_short_notice)
              expect(grouped_answers[2].value).to eq('yes')

              expect(grouped_answers[3]).to be_an_instance_of(FreeTextAnswer)
              expect(grouped_answers[3].question).to eq(:urgent_hearing_short_notice_details)
              expect(grouped_answers[3].value).to eq('short notice details')
            end
          end
        end
      end
    end
  end
end
