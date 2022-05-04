require 'spec_helper'

module Summary
  describe Sections::C1aGettingSupport do
    let(:c100_application) {
      instance_double(C100Application,
    ) }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:c1a_getting_support) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      it 'has the correct rows' do
        expect(answers.count).to eq(2)

        expect(answers[0]).to be_an_instance_of(Partial)
        expect(answers[0].name).to eq(:page_break)

        expect(answers[1]).to be_an_instance_of(Partial)
        expect(answers[1].name).to eq(:c1a_getting_support)
      end
    end
  end
end
