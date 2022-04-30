require 'rails_helper'

RSpec.describe Relation do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        mother
        father
        guardian
        special_guardian
        grand_parent
        other
      ))
    end
  end
end
