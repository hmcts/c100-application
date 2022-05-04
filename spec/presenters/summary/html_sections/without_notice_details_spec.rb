require 'spec_helper'

module Summary
  describe HtmlSections::WithoutNoticeDetails do
    let(:c100_application) {
      instance_double(C100Application,
        given_answers
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    let(:without_notice_hearing_requested){
      {
        without_notice: 'yes',
        without_notice_details: 'details',
        without_notice_impossible: 'yes',
        without_notice_impossible_details: 'details',
        without_notice_frustrate: 'yes',
        without_notice_frustrate_details: 'details'
      }
    }
    let(:without_notice_hearing_not_requested){
      {
        without_notice: 'no',
        without_notice_details: nil,
        without_notice_impossible: nil,
        without_notice_impossible_details: nil,
        without_notice_frustrate: nil,
        without_notice_frustrate_details: nil
      }
    }
    let(:given_answers) { without_notice_hearing_requested }

    describe '#name' do
      it { expect(subject.name).to eq(:without_notice_hearing) }
    end

    describe '#answers' do
      describe 'the first row' do
        let(:row){ answers[0] }

        it 'is an Answer' do
          expect(row).to be_an_instance_of(Answer)
        end

        it 'has the correct question' do
          expect(row.question).to eq(:without_notice_hearing)
        end

        it 'has the correct change_path' do
          expect(row.change_path).to eq('/steps/application/without_notice')
        end
      end

      context 'when the user has not asked for a without notice hearing' do
        let(:given_answers) { without_notice_hearing_not_requested }

        it 'has only one row' do
          expect(answers.count).to eq(1)
        end
      end

      context 'when the user has asked for a without notice hearing' do
        let(:given_answers) { without_notice_hearing_requested }

        it 'has two rows' do
          expect(answers.count).to eq(2)
        end

        describe 'the second row' do
          let(:row){ answers[1] }

          it 'is an AnswersGroup' do
            expect(row).to be_an_instance_of(AnswersGroup)
          end

          it 'has the correct name' do
            expect(row.name).to eq(:without_notice_hearing_details)
          end

          it 'has the correct change_path' do
            expect(row.change_path).to eq('/steps/application/without_notice_details')
          end

          describe 'the grouped answers' do
            let(:grouped_answers){ row.answers }

            it 'has the right number of answers' do
              expect(grouped_answers.count).to eq(5)
            end

            it 'has the right rows' do
              expect(grouped_answers[0]).to be_an_instance_of(FreeTextAnswer)
              expect(grouped_answers[0].question).to eq(:without_notice_details)
              expect(c100_application).to have_received(:without_notice_details)

              expect(grouped_answers[1]).to be_an_instance_of(Answer)
              expect(grouped_answers[1].question).to eq(:without_notice_impossible)
              expect(c100_application).to have_received(:without_notice_impossible)

              expect(grouped_answers[2]).to be_an_instance_of(FreeTextAnswer)
              expect(grouped_answers[2].question).to eq(:without_notice_impossible_details)
              expect(c100_application).to have_received(:without_notice_impossible_details)

              expect(grouped_answers[3]).to be_an_instance_of(Answer)
              expect(grouped_answers[3].question).to eq(:without_notice_frustrate)
              expect(c100_application).to have_received(:without_notice_frustrate)

              expect(grouped_answers[4]).to be_an_instance_of(FreeTextAnswer)
              expect(grouped_answers[4].question).to eq(:without_notice_frustrate_details)
              expect(c100_application).to have_received(:without_notice_frustrate_details)
            end
          end

        end

      end
    end
  end
end
