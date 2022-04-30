require 'spec_helper'

RSpec.describe SafetyConcernsPresenter do
  subject { described_class.new(c100_application) }

  let(:c100_application) { C100Application.new(substance_abuse: 'yes', domestic_abuse: 'no') }

  describe '#concern_types' do
    it {
      expect(
        subject.concern_types
      ).to eq([:domestic_abuse, :risk_of_abduction, :children_abuse, :substance_abuse, :other_abuse])
    }
  end

  describe '#concerns' do
    let(:concerns) { subject.concerns }

    it 'retrieves the concerns raised by the user' do
      expect(concerns.size).to eq(1)

      expect(concerns[0].type_name).to eq(:substance_abuse)
      expect(concerns[0].to_partial_path).to eq('steps/miam_exemptions/shared/concern')
    end

    context 'when there are no concerns' do
      let(:c100_application) { C100Application.new }

      it { expect(concerns).to eq([]) }
    end
  end
end
