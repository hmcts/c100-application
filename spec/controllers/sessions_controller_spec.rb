require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#ping' do
    it 'does nothing and returns 204' do
      get :ping
      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#destroy' do
    it 'resets the session' do
      expect(subject).to receive(:reset_session)
      get :destroy
    end

    it 'redirects to the home page' do
      get :destroy
      expect(subject).to redirect_to(root_path)
    end

    context 'when a JSON request is made' do
      before { request.accept = "application/json" }

      it 'returns empty JSON and does not redirect' do
        expect(response.body).to be_empty
        expect(response.location).to be_nil
      end
    end
  end
end
