require 'spec_helper'

module Summary
  describe HtmlSections::ChildrenAbuseDetails do
    let(:c100_application) { instance_double(C100Application, abuse_concerns: abuse_concerns_resultset) }
    let(:abuse_concerns_resultset) { double('abuse_concerns_resultset') }

    let(:abuse_concern) {
      instance_double(
        AbuseConcern,
        subject: 'children',
        kind: 'emotional',
        answer: 'yes',
        behaviour_description: 'behaviour_description',
        behaviour_start: '2001',
        behaviour_ongoing: 'no',
        behaviour_stop: '2010',
        asked_for_help: 'yes',
        help_party: 'friend',
        help_provided: 'yes',
        help_description: 'help_description'
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:children_abuse_details)
      end
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      let(:found_abuses_resultset) { [abuse_concern] }

      before do
        allow(
          abuse_concerns_resultset
        ).to receive(:where).with(
          subject: AbuseSubject::CHILDREN
        ).and_return(found_abuses_resultset)
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(2)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:abuse_emotional)
        expect(answers[0].change_path).to eq('/steps/abuse_concerns/question?kind=emotional&subject=children')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(AnswersGroup)
        expect(answers[1].name).to eq(:abuse_details)
        expect(answers[1].change_path).to eq('/steps/abuse_concerns/details?kind=emotional&subject=children')
        expect(answers[1].answers.count).to eq(8)

          ## abuse_details group answers ###
          details = answers[1].answers

          expect(details[0]).to be_an_instance_of(FreeTextAnswer)
          expect(details[0].question).to eq(:abuse_behaviour_description)
          expect(details[0].value).to eq('behaviour_description')

          expect(details[1]).to be_an_instance_of(FreeTextAnswer)
          expect(details[1].question).to eq(:abuse_behaviour_start)
          expect(details[1].value).to eq('2001')

          expect(details[2]).to be_an_instance_of(Answer)
          expect(details[2].question).to eq(:abuse_behaviour_ongoing)
          expect(details[2].value).to eq('no')

          expect(details[3]).to be_an_instance_of(FreeTextAnswer)
          expect(details[3].question).to eq(:abuse_behaviour_stop)
          expect(details[3].value).to eq('2010')

          expect(details[4]).to be_an_instance_of(Answer)
          expect(details[4].question).to eq(:abuse_asked_for_help)
          expect(details[4].value).to eq('yes')

          expect(details[5]).to be_an_instance_of(FreeTextAnswer)
          expect(details[5].question).to eq(:abuse_help_party)
          expect(details[5].value).to eq('friend')

          expect(details[6]).to be_an_instance_of(Answer)
          expect(details[6].question).to eq(:abuse_help_provided)
          expect(details[6].value).to eq('yes')

          expect(details[7]).to be_an_instance_of(FreeTextAnswer)
          expect(details[7].question).to eq(:abuse_help_description)
          expect(details[7].value).to eq('help_description')
      end
    end
  end
end
