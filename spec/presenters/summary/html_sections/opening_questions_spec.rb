require 'spec_helper'

module Summary
  describe HtmlSections::OpeningQuestions do
    let(:c100_application) {
      instance_double(C100Application,
        consent_order: 'no',
        child_protection_cases: 'no',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:opening_questions) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:consent_order_application)
        expect(answers[0].change_path).to eq('/steps/opening/consent_order')
        expect(answers[0].value).to eq('no')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:child_protection_cases)
        expect(answers[1].change_path).to eq('/steps/opening/child_protection_cases')
        expect(answers[1].value).to eq('no')
      end
    end
  end
end
