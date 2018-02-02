require 'spec_helper'

module Summary
  describe Sections::ApplicationReasons do
    let(:c100_application) {
      instance_double(C100Application,
        application_details: 'details',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:application_reasons) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:applied_for_permission)
        expect(answers[0].value).to eq(GenericYesNo::NO)

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:application_details)
        expect(c100_application).to have_received(:application_details)
      end
    end
  end
end