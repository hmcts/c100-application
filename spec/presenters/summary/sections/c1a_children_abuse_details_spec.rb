require 'spec_helper'

module Summary
  describe Sections::C1aChildrenAbuseDetails do
    let(:c100_application) { instance_double(C100Application, abuse_concerns: abuse_concerns_resultset) }
    let(:abuse_concerns_resultset) { double('abuse_concerns_resultset') }

    let(:abuse_concern) {
      instance_double(
        AbuseConcern,
        subject: 'children',
        kind: 'emotional',
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
        expect(subject.name).to eq(:c1a_children_abuse_details)
      end
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    # The following tests can be fragile, but on purpose. During the development phase
    # we have to update the tests each time we introduce a new row or remove another.
    # But once it is finished and stable, it will raise a red flag if it ever gets out
    # of sync, which means a quite solid safety net for any maintainers in the future.
    #
    describe '#answers' do
      let(:found_abuses_resultset) { double('found_abuses_resultset') }
      let(:filtered_abuses_resultset) { [abuse_concern] }

      before do
        allow(
          abuse_concerns_resultset
        ).to receive(:where).with(
          answer: GenericYesNo::YES, subject: AbuseSubject::CHILDREN
        ).and_return(found_abuses_resultset)

        allow(
          found_abuses_resultset
        ).to receive_message_chain(:where, :not).with(
          kind: ['other']
        ).and_return(filtered_abuses_resultset)
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(10)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_abuse_type)
        expect(answers[0].value).to eq('children.emotional')

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:c1a_abuse_behaviour_description)
        expect(answers[1].value).to eq('behaviour_description')

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:c1a_abuse_behaviour_start)
        expect(answers[2].value).to eq('2001')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:c1a_abuse_behaviour_ongoing)
        expect(answers[3].value).to eq('no')

        expect(answers[4]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[4].question).to eq(:c1a_abuse_behaviour_stop)
        expect(answers[4].value).to eq('2010')

        expect(answers[5]).to be_an_instance_of(Answer)
        expect(answers[5].question).to eq(:c1a_abuse_asked_for_help)
        expect(answers[5].value).to eq('yes')

        expect(answers[6]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[6].question).to eq(:c1a_abuse_help_party)
        expect(answers[6].value).to eq('friend')

        expect(answers[7]).to be_an_instance_of(Answer)
        expect(answers[7].question).to eq(:c1a_abuse_help_provided)
        expect(answers[7].value).to eq('yes')

        expect(answers[8]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[8].question).to eq(:c1a_abuse_help_description)
        expect(answers[8].value).to eq('help_description')

        expect(answers[9]).to be_an_instance_of(Partial)
        expect(answers[9].name).to eq(:row_blank_space)
      end

      context 'when behaviour ongoing and no help seek' do
        let(:abuse_concern) {
          instance_double(
            AbuseConcern,
            subject: 'children',
            kind: 'emotional',
            behaviour_description: 'behaviour_description',
            behaviour_start: '2001',
            behaviour_ongoing: 'yes',
            behaviour_stop: nil,
            asked_for_help: 'no',
            help_party: nil,
            help_provided: nil,
            help_description: nil
          )
        }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(6)
        end

        it 'has the correct rows in the right order' do
          expect(answers[0]).to be_an_instance_of(Answer)
          expect(answers[0].question).to eq(:c1a_abuse_type)
          expect(answers[0].value).to eq('children.emotional')

          expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[1].question).to eq(:c1a_abuse_behaviour_description)
          expect(answers[1].value).to eq('behaviour_description')

          expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
          expect(answers[2].question).to eq(:c1a_abuse_behaviour_start)
          expect(answers[2].value).to eq('2001')

          expect(answers[3]).to be_an_instance_of(Answer)
          expect(answers[3].question).to eq(:c1a_abuse_behaviour_ongoing)
          expect(answers[3].value).to eq('yes')

          expect(answers[4]).to be_an_instance_of(Answer)
          expect(answers[4].question).to eq(:c1a_abuse_asked_for_help)
          expect(answers[4].value).to eq('no')

          expect(answers[5]).to be_an_instance_of(Partial)
          expect(answers[5].name).to eq(:row_blank_space)
        end
      end
    end
  end
end
