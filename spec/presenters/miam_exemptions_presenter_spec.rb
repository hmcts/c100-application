require 'spec_helper'

RSpec.describe MiamExemptionsPresenter do
  subject { described_class.new(miam_exemption) }

  let(:miam_exemption) { MiamExemption.new(domestic: domestic_exemptions) }
  let(:domestic_exemptions) { %w(police_conviction specialist_examination) }

  describe '#exemption_groups' do
    it { expect(subject.exemption_groups).to eq([:domestic, :protection, :urgency, :adr, :misc]) }
  end

  describe '#exemptions' do
    let(:exemptions) { subject.exemptions }

    before do
      # We mock just one group to simplify the tests, as the behaviour is identical
      # for one or for five groups.
      allow(subject).to receive(:exemption_groups).and_return([:domestic])
    end

    it 'retrieves the exemptions from the groups' do
      expect(exemptions.size).to eq(1)

      expect(exemptions[0].group_name).to eq(:domestic)
      expect(exemptions[0].collection).to eq(domestic_exemptions)
      expect(exemptions[0].to_partial_path).to eq('steps/miam_exemptions/shared/exemption')
    end

    context 'filter out `group_xxx` items' do
      let(:domestic_exemptions) { %w(group_police police_conviction) }

      it 'retrieves the exemptions from the groups' do
        expect(exemptions[0].collection).to eq(['police_conviction'])
      end
    end

    context 'filter out `xxx_none` items' do
      let(:domestic_exemptions) { %w(domestic_none) }

      it 'retrieves the exemptions from the groups' do
        expect(exemptions.size).to eq(0)
      end
    end

    context 'when there are no exemptions' do
      let(:miam_exemption) { nil }

      it { expect(exemptions).to eq([]) }
    end
  end

  describe '#selection_for' do
    let(:domestic_exemptions) { %w(group_police police_conviction domestic_none) }

    context 'when there are no exemptions' do
      let(:miam_exemption) { nil }
      it { expect(subject.selection_for(:domestic)).to eq([]) }
    end

    context 'when a filter is not provided' do
      it 'retrieves the exemptions from the given group, using the default filter' do
        expect(subject.selection_for(:domestic)).to eq(['police_conviction'])
      end
    end

    context 'when a filter is provided' do
      it 'retrieves the exemptions from the given group, using the default filter' do
        expect(subject.selection_for(:domestic, filter: :groups)).to eq(%w(police_conviction domestic_none))
      end
    end
  end
end
