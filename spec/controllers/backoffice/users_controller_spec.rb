require 'rails_helper'

RSpec.describe Backoffice::UsersController do

  before do
    allow(subject).to receive(:authenticate).and_return(true)
  end

  describe '#exists' do

    before do
      @user = BackofficeUser.create(email: 'test@example.com')
    end

    after do
      @user.destroy
    end

    it 'finds users that exist' do
      get :exists, params: { id: 'test@example.com' }
      expect(response).to be_successful
    end

    it 'is case insensitive to email' do
      get :exists, params: { id: 'TEST@example.com' }
      expect(response).to be_successful
    end

    it 'does not allow users that do not exist' do
      get :exists, params: { id: 'INVALID@example.com' }
      expect(response.status).to eq(404)
    end


  end

end
