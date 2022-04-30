require 'spec_helper'

module Summary
  describe Sections::HelpWithFees do
    let(:c100_application) { instance_double(C100Application, hwf_reference_number: nil) }
    subject { described_class.new(c100_application) }

    describe '#name' do
      it 'is expected to be correct' do
        expect(subject.name).to eq(:help_with_fees)
      end
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(subject.answers.count).to eq(1)

        expect(subject.answers[0]).to be_an_instance_of(FreeTextAnswer)
      end
    end
  end
end
