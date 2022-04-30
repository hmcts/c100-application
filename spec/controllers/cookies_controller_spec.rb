require 'rails_helper'

RSpec.describe CookiesController do
  describe '#edit' do
    it 'renders the expected page' do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe '#create' do
    it 'redirects to the correct place' do
      post :create, params: { cookie: { usage: true, return_path: '/test' } }
      expect(response).to redirect_to('/test')
    end
  end

  describe '#update' do
    it 'redirects to the correct place' do
      patch :update, params: { cookie: { usage: true } }
      expect(response).to redirect_to('/about/cookies')
    end
  end
end
