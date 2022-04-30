require 'rails_helper'

RSpec.describe PaymentType do
  let(:value) { :foo }
  subject     { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        online
        help_with_fees
        solicitor
        self_payment_card
        self_payment_cheque
      ))
    end
  end
end
