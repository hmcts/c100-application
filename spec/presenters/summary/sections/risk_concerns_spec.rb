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
      it { expect(subject.to_partial_path).to eq('steps/completion/shared/risk_concerns') }
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

    describe '#c1a_triggered?' do
      it 'uses the implementation in the c100 application' do
        expect(c100_application).to receive(:has_safety_concerns?).and_return(true)
        expect(subject.c1a_triggered?).to eq(true)
      end
    end

    describe '#confidentiality_enabled?' do
      it 'uses the implementation in the c100 application' do
        expect(c100_application).to receive(:confidentiality_enabled?).and_return(true)
        expect(subject.confidentiality_enabled?).to eq(true)
      end
    end
  end
end
