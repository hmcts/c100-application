require 'rails_helper'

RSpec.describe C100App::OnlinePayments do
  let(:payment_id) { 12345 }
  let(:state) { { foo: 'bar' } }

  let(:payment_intent) {
    instance_double(
      PaymentIntent,
      state: state,
      c100_application: c100_application,
      payment_id: payment_id,
      return_url: 'https://c100.justice.uk',
    )
  }

  let(:c100_application) {
    C100Application.new(
      id: '449362af-0bc3-4953-82a7-1363d479b876',
      created_at: Time.at(0),
      updated_at: Time.at(100),
      receipt_email: 'applicant@test.com',
    )
  }

  describe 'NON_RETRYABLE_CODES' do
    it 'returns the expected codes' do
      expect(described_class::NON_RETRYABLE_CODES).to match_array(%w[P0030 P0050])
    end
  end

  describe '.create_payment' do
    subject(:do_request) { described_class.create_payment(payment_intent) }

    let(:court_double) { double('Court', name: 'Test court', documents_email: 'court@example.com', gbs: 'X123') }
    let(:response_double) {
      double(call: double(
        'Response', payment_id: payment_id, state: state, payment_url: 'https://payments.example.com'
      ))
    }

    let(:payload) do
      {
        amount: 232_00,
        description: 'Court fee for a child arrangements application (C100)',
        reference: '1970/01/449362AF',
        email: 'applicant@test.com',
        return_url: 'https://c100.justice.uk',
        metadata: {
          application: 'C100',
          court_gbs: 'X123',
          court_name: 'Test court',
          court_email: 'court@example.com',
        }
      }
    end

    before do
      allow(c100_application).to receive(:court).and_return(court_double)

      allow(
        PaymentsApi::Requests::CreateCardPayment
      ).to receive(:new).with(payload).and_return(response_double)
    end

    context 'payment intent' do
      it 'updates the payment intent' do
        expect(
          payment_intent
        ).to receive(:update).with(payment_id: payment_id, state: state)

        expect(do_request.payment_url).to eq('https://payments.example.com')
      end
    end
  end

  describe '.retrieve_payment' do
    subject(:do_request) { described_class.retrieve_payment(payment_intent) }

    let(:response_double) {
      double(call: double('Response', payment_id: payment_id, state: state, success?: true))
    }

    before do
      allow(
        PaymentsApi::Requests::GetCardPayment
      ).to receive(:new).with(payment_id: payment_id).and_return(response_double)

      allow(payment_intent).to receive(:update)
    end

    context 'payment intent' do
      it 'updates the payment intent' do
        expect(
          payment_intent
        ).to receive(:update).with(payment_id: payment_id, state: state)

        expect(do_request.success?).to eq(true)
      end
    end
  end

  describe '.non_retryable_state?' do
    let(:state) { { 'code' => state_code } }

    context 'non-retryable state code' do
      let(:state_code) { 'P0030' }

      it 'returns true for a non-retryable state code' do
        expect(described_class.non_retryable_state?(payment_intent)).to eq(true)
      end
    end

    context 'any other state code' do
      let(:state_code) { 'P0010' }

      it 'returns false for any other state code' do
        expect(described_class.non_retryable_state?(payment_intent)).to eq(false)
      end
    end
  end
end
