require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:c100_application) { instance_double(C100Application) }
  let(:payment_intent) { instance_double(PaymentIntent) }

  describe '#validate' do
    before do
      allow(controller).to receive(:current_c100_application).and_return(c100_application)
    end

    context 'when there is no application in the session' do
      let(:c100_application) { nil }

      it 'raises an exception' do
        expect {
          get :validate, params: { id: 'intent-uuid', nonce: '123456' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when there is an application in the session but details do not match' do
      it 'raises an exception' do
        expect {
          get :validate, params: { id: 'intent-uuid', nonce: '123456' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for a request with missing mandatory params' do
      it 'redirects to the invalid session error page' do
        expect {
          get :validate, params: { id: 'intent-uuid' } # nonce param is omitted
        }.to raise_error(ActionController::ParameterMissing)
      end
    end

    context 'for a valid request' do
      before do
        allow(
          PaymentIntent
        ).to receive(:find_by!).with(
          id: 'intent-uuid', nonce: '123456', c100_application: c100_application
        ).and_return(payment_intent)

        allow(
          C100App::PaymentsFlowControl
        ).to receive(:new).with(c100_application).and_return(double(next_url: 'https://payments.example.com'))
      end

      it 'invalidates the current URL to avoid reuse and redirects to the payments vendor' do
        expect(payment_intent).to receive(:revoke_nonce!)

        get :validate, params: { id: 'intent-uuid', nonce: '123456' }
        expect(response).to redirect_to('https://payments.example.com')
      end
    end
  end
end
