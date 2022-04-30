require 'rails_helper'

RSpec.describe GenderAttribute do
  subject { described_class.build(GenderAttribute) }

  let(:coerced_value) { subject.coerce(value) }

  describe 'when value is `nil`' do
    let(:value) { nil }
    it { expect(coerced_value).to be_nil }
  end

  describe 'when value is a symbol' do
    let(:value) { :female }
    it { expect(coerced_value).to eq(Gender::FEMALE) }
  end

  describe 'when value is a string' do
    let(:value) { 'female' }
    it { expect(coerced_value).to eq(Gender::FEMALE) }
  end

  describe 'when value is already a value-object' do
    let(:value) { Gender::FEMALE }
    it { expect(coerced_value).to eq(Gender::FEMALE) }
  end
end
