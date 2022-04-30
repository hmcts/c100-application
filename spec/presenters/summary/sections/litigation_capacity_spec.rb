require 'spec_helper'

module Summary
  describe Sections::LitigationCapacity do
    let(:c100_application) {
      instance_double(C100Application,
        reduced_litigation_capacity: 'yes',
        participation_capacity_details: 'details',
        participation_other_factors_details: 'details',
        participation_referral_or_assessment_details: 'details',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:litigation_capacity) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:reduced_litigation_capacity)
        expect(c100_application).to have_received(:reduced_litigation_capacity)

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:participation_capacity_details)
        expect(c100_application).to have_received(:participation_capacity_details)

        expect(answers[2]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[2].question).to eq(:participation_other_factors_details)
        expect(c100_application).to have_received(:participation_other_factors_details)

        expect(answers[3]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[3].question).to eq(:participation_referral_or_assessment_details)
        expect(c100_application).to have_received(:participation_referral_or_assessment_details)
      end
    end
  end
end
