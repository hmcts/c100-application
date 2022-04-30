require 'spec_helper'

module Summary
  describe HtmlSections::MiamExemptions do
    let(:c100_application) {
      instance_double(C100Application,
        miam_exemption: miam_exemption,
    ) }

    let(:miam_exemption) {
      MiamExemption.new(
        domestic: [:test_domestic],
        protection: [:test_protection],
        urgency: [:test_urgency],
        adr: [:test_adr],
        misc: [:test_misc],
      )
    }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:miam_exemptions) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(5)

        expect(answers[0]).to be_an_instance_of(MultiAnswer)
        expect(answers[0].question).to eq(:miam_exemptions_domestic)
        expect(answers[0].value).to eq(['test_domestic'])
        expect(answers[0].change_path).to eq('/steps/miam_exemptions/domestic')

        expect(answers[1]).to be_an_instance_of(MultiAnswer)
        expect(answers[1].question).to eq(:miam_exemptions_protection)
        expect(answers[1].value).to eq(['test_protection'])
        expect(answers[1].change_path).to eq('/steps/miam_exemptions/protection')

        expect(answers[2]).to be_an_instance_of(MultiAnswer)
        expect(answers[2].question).to eq(:miam_exemptions_urgency)
        expect(answers[2].value).to eq(['test_urgency'])
        expect(answers[2].change_path).to eq('/steps/miam_exemptions/urgency')

        expect(answers[3]).to be_an_instance_of(MultiAnswer)
        expect(answers[3].question).to eq(:miam_exemptions_adr)
        expect(answers[3].value).to eq(['test_adr'])
        expect(answers[3].change_path).to eq('/steps/miam_exemptions/adr')

        expect(answers[4]).to be_an_instance_of(MultiAnswer)
        expect(answers[4].question).to eq(:miam_exemptions_misc)
        expect(answers[4].value).to eq(['test_misc'])
        expect(answers[4].change_path).to eq('/steps/miam_exemptions/misc')
      end
    end
  end
end
