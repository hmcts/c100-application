require 'spec_helper'

module Summary
  describe Sections::MiamExemptions do
    let(:c100_application) { instance_double(C100Application, miam_exemption: miam_exemption) }
    let(:miam_exemption)   { nil }

    subject { described_class.new(c100_application) }

    let(:answers) { subject.answers }

    describe '#name' do
      it { expect(subject.name).to eq(:miam_exemptions) }
    end

    describe '#show_header?' do
      it { expect(subject.show_header?).to eq(false) }
    end

    describe '#answers' do
      context 'when no exemptions present' do
        let(:miam_exemption) { MiamExemption.new }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(1)
        end

        it 'has the correct rows in the right order' do
          expect(answers[0]).to be_an_instance_of(Separator)
          expect(answers[0].title).to eq(:not_applicable)
        end
      end

      context 'when there are exemptions' do
        let(:miam_exemption) { MiamExemption.new(domestic: ['court_undertaking']) }

        it 'has the correct number of rows' do
          expect(answers.count).to eq(1)
        end

        it 'has the correct rows in the right order' do
          expect(answers[0]).to be_an_instance_of(Partial)
          expect(answers[0].name).to eq(:miam_exemptions)
        end

        it 'propagates to the Partial the exemption collection as an ivar' do
          ivar = answers[0].ivar
          expect(ivar.size).to eq(1)
          expect(ivar[0].group_name).to eq(:domestic)
          expect(ivar[0].collection).to eq(['court_undertaking'])
        end
      end
    end
  end
end
