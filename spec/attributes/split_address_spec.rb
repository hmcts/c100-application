require 'rails_helper'

RSpec.describe SplitAddress do
  subject { described_class.build(SplitAddress) }

  let(:coerced_value) { subject.coerce(value) }

  describe 'when value is `nil`' do
    let(:value) { nil }
    it { expect(coerced_value).to be_nil }
  end

  describe 'when value is an empty string' do
    let(:value) { '' }
    it { expect(coerced_value).to be_nil }
  end

  describe 'when value has all expected tokens' do
    let(:value) { 'address_line_1|address_line_2|address_line_3|town|country|postcode' }
    it {
      expect(coerced_value).to eq({
        address_line_1: 'address_line_1',
        address_line_2: 'address_line_2',
        address_line_3: 'address_line_3',
        town: 'town',
        country: 'country',
        postcode: 'postcode'
      })
    }
  end

  describe 'when value is missing some of the tokens' do
    let(:value) { 'address_line_1||||country|postcode' }
    it {
      expect(coerced_value).to eq({
        address_line_1: 'address_line_1',
        address_line_2: '',
        address_line_3: '',
        town: '',
        country: 'country',
        postcode: 'postcode'
      })
    }
  end
end
