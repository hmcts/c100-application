require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do
  before do
    allow(ENV).to receive(:[]).with('GOVUK_NOTIFY_BEARER_TOKEN').and_return('test-token')
  end

  describe '#notify' do
    let(:payload) { { something: 'test' }.to_json }
    let(:cb_double) { double.as_null_object }

    context 'unauthorized requests' do
      it 'does not call forgery protection' do
        expect(controller).not_to receive(:verify_authenticity_token)
        post :notify, body: payload
      end

      it 'returns 401 Unauthorized' do
        post :notify, body: payload
        expect(response.status).to eq(401)
      end
    end

    context 'authorized requests' do
      before do
        request.headers['HTTP_AUTHORIZATION'] = \
          ActionController::HttpAuthentication::Token.encode_credentials('test-token')
      end

      context 'for a successful callback' do
        before do
          request.content_type = 'application/json'
        end

        it 'does not call forgery protection' do
          expect(controller).not_to receive(:verify_authenticity_token)
          post :notify, body: payload
        end

        it 'returns 200 OK' do
          post :notify, body: payload
          expect(response.status).to eq(200)
        end

        it 'process the callback payload' do
          expect(C100App::NotifyCallback).to receive(:new).with(
            { 'something' => 'test' }
          ).and_return(cb_double)

          expect(cb_double).to receive(:process!)

          post :notify, body: payload
        end
      end

      context 'for an unsuccessful callback' do
        it 'returns 500 Error' do
          post :notify, body: ''
          expect(response.status).to eq(500)
        end

        it 'captures the exception' do
          expect(Raven).to receive(:capture_exception).with(ActionController::ParameterMissing)
          post :notify, body: ''
        end
      end
    end
  end
end
