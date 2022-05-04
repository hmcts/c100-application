require 'spec_helper'

module Summary
  describe HtmlSections::SafetyContact do
    let(:c100_application) {
      instance_double(
        C100Application,
        concerns_contact_type: 'yes',
        concerns_contact_other: 'no',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:safety_contact) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:concerns_contact_type)
        expect(answers[0].change_path).to eq('/steps/abuse_concerns/contact')
        expect(answers[0].value).to eq('yes')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:concerns_contact_other)
        expect(answers[1].change_path).to eq('/steps/abuse_concerns/contact')
        expect(answers[1].value).to eq('no')
      end
    end
  end
end
