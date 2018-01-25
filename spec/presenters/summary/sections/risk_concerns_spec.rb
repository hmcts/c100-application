require 'spec_helper'

module Summary
  describe Sections::RiskConcerns do
    let(:c100_application) { double(C100Application).as_null_object }
    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:risk_concerns)
      end
    end

    describe '#to_partial_path' do
      it { expect(subject.to_partial_path).to eq('shared/risk_concerns') }
    end

    describe '#answers' do
      it 'has the correct number of rows' do
        expect(answers.count).to eq(5)
      end

      it 'has the correct rows in the right order' do
        expect(answers[0]).to be_an_instance_of(Answer)
        expect(answers[0].question).to eq(:domestic_abuse)
        expect(c100_application).to have_received(:domestic_abuse)

        expect(answers[1]).to be_an_instance_of(Answer)
        expect(answers[1].question).to eq(:children_abduction)
        expect(c100_application).to have_received(:risk_of_abduction)

        expect(answers[2]).to be_an_instance_of(Answer)
        expect(answers[2].question).to eq(:children_abuse)
        expect(c100_application).to have_received(:children_abuse)

        expect(answers[3]).to be_an_instance_of(Answer)
        expect(answers[3].question).to eq(:substance_abuse)
        expect(c100_application).to have_received(:substance_abuse)

        expect(answers[4]).to be_an_instance_of(Answer)
        expect(answers[4].question).to eq(:other_concerns)
        expect(c100_application).to have_received(:other_abuse)
      end
    end

    describe '#any?' do
      let(:c100_application) {
        instance_double(C100Application,
          domestic_abuse: domestic_abuse,
          risk_of_abduction: 'no',
          children_abuse: 'no',
          substance_abuse: 'no',
          other_abuse: 'no'
        )
      }

      context 'at least one concern was answered as `YES`' do
        let(:domestic_abuse) { 'yes' }

        it 'returns true' do
          expect(subject.any?).to eq(true)
        end
      end

      context 'there are no concerns' do
        let(:domestic_abuse) { 'no' }

        it 'returns false' do
          expect(subject.any?).to eq(false)
        end
      end
    end
  end
end