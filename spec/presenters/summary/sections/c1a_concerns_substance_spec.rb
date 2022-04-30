require 'spec_helper'

module Summary
  describe Sections::C1aConcernsSubstance do
    let(:c100_application) {
      instance_double(
        C100Application,
        substance_abuse: substance_abuse,
        substance_abuse_details: 'details',
    ) }

    subject { described_class.new(c100_application) }

    let(:substance_abuse) { 'yes' }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c1a_concerns_details) }
    end

    describe '#show?' do
      it { expect(subject.show?).to eq(true) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(3)

        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:c1a_abuse_type)
        expect(answers[0].value).to eq(:substance_abuse)

        expect(answers[1]).to be_an_instance_of(FreeTextAnswer)
        expect(answers[1].question).to eq(:c1a_abuse_details)
        expect(answers[1].value).to eq('details')

        expect(answers[2]).to be_an_instance_of(Partial)
        expect(answers[2].name).to eq(:row_blank_space)
      end

      context 'when there is no substance abuse' do
        let(:substance_abuse) { 'no' }

        it 'has the correct rows' do
          expect(answers.count).to eq(0)
        end
      end
    end
  end
end
