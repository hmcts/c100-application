require 'spec_helper'

module Summary
  describe Sections::WithoutNoticeHearing do
    let(:c100_application) {
      instance_double(C100Application,
        without_notice: 'yes',
        without_notice_details: 'details',
        without_notice_impossible: 'yes',
        without_notice_impossible_details: 'details',
        without_notice_frustrate: 'yes',
        without_notice_frustrate_details: 'details'
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:without_notice_hearing) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(6)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:without_notice_hearing_details)
        expect(c100_application).to have_received(:without_notice)

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:without_notice_details)
        expect(c100_application).to have_received(:without_notice_details)

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:without_notice_impossible)
        expect(c100_application).to have_received(:without_notice_impossible)

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:without_notice_impossible_details)
        expect(c100_application).to have_received(:without_notice_impossible_details)

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:without_notice_frustrate)
        expect(c100_application).to have_received(:without_notice_frustrate)

        expect(answers[5]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[5].question).to eq(:without_notice_frustrate_details)
        expect(c100_application).to have_received(:without_notice_frustrate_details)
      end
    end
  end
end
