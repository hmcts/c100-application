require 'spec_helper'

module Summary
  describe HtmlSections::MiamRequirement do
    let(:c100_application) {
      instance_double(C100Application,
        miam_attended: 'no',
        miam_mediator_exemption: 'yes',
        miam_certification: 'yes',
        miam_exemption_claim: 'no',
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:miam_requirement) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(4)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:miam_attended)
        expect(answers[0].change_path).to eq('/steps/miam/attended')
        expect(answers[0].value).to eq('no')

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:miam_mediator_exemption)
        expect(answers[1].change_path).to eq('/steps/miam/mediator_exemption')
        expect(answers[1].value).to eq('yes')

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:miam_certification)
        expect(answers[2].change_path).to eq('/steps/miam/certification')
        expect(answers[2].value).to eq('yes')

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:miam_exemption_claim)
        expect(answers[3].change_path).to eq('/steps/miam/exemption_claim')
        expect(answers[3].value).to eq('no')
      end
    end
  end
end
