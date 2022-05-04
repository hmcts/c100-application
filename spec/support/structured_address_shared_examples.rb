require 'rails_helper'

RSpec.shared_examples 'a model with structured address details' do
  describe '#full_address' do
    subject { described_class.new(arguments) }

    let(:arguments) do
      {
        address_data: {
          address_line_1: 'address_line_1',
          address_line_2: '',
          town: 'town',
          country: 'country',
          postcode: 'postcode'
        }
      }
    end

    it { expect(subject.full_address).to eq('address_line_1, town, country, postcode') }

    context 'when the hash keys are in a different order or missing' do
      let(:arguments) do
        {
          address_data: {
            postcode: 'postcode',
            country: 'country',
            address_line_1: 'address_line_1',
            town: 'town',
          }
        }
      end

      it 'returns the value in the expected order' do
        expect(subject.full_address).to eq('address_line_1, town, country, postcode')
      end
    end
  end
end
