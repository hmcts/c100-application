require 'spec_helper'

module Summary
  describe Sections::C1aChildrenOtherAbuseDetails do
    let(:c100_application) { instance_double(C100Application, abuse_concerns: abuse_concerns_resultset) }
    let(:abuse_concerns_resultset) { double('abuse_concerns_resultset') }

    let(:abuse_concern) {
      instance_double(
        AbuseConcern,
        subject: 'children',
        kind: 'other',
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
        expect(subject.name).to eq(:c1a_children_other_abuse_details)
      end
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

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
          kind: %w(physical emotional psychological sexual financial)
        ).and_return(filtered_abuses_resultset)
      end

      it 'has the correct number of rows' do
        expect(answers.count).to eq(10)
      end

      it 'has the correct rows in the right order' do
        #
        # NOTE: this presenter uses exactly the same code as
        # `C1aChildrenAbuseDetails`, but for abuse kind `other`.
        # Refer to the above presenter spec for a full test.
        #
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_abuse_type)
        expect(answers[0].value).to eq('children.other')
      end
    end
  end
end
