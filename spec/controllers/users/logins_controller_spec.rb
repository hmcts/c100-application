require 'rails_helper'

RSpec.describe Users::LoginsController do
  let(:c100_application) { double.as_null_object }

  before do
    allow(subject).to receive(:current_c100_application).and_return(c100_application)
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#new' do
    it 'responds with HTTP success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    let(:user) { User.new(email: 'foo@bar.com') }

    def do_post
      post :create, params: { 'user' => {
        email: 'foo@bar.com',
        password: 'passw0rd'
      } }
    end

    context 'when the registration was successful' do
      let(:c100_application) { instance_double(C100Application, user: user) }

      before do
        expect(warden).to receive(:authenticate!).and_return(user)
      end

      it 'does not update `current_sign_in_at` attribute (user is not automatically signed-in)' do
        expect { do_post }.not_to change(user, :current_sign_in_at)
      end

      it 'redirects to the confirmation page' do
        do_post
        expect(response.location).to match(users_login_save_confirmation_path)
      end

      context 'when the case already belongs to the user (we do not send an email)' do
        it 'does not store the signed in email address in the session' do
          do_post
          expect(session[:confirmation_email_address]).to be_nil
        end
      end

      context 'when the case is new and we are linking it to the user (we send an email)' do
        before do
          expect(
            C100App::SaveApplicationForLater
          ).to receive(:new).with(
            c100_application, user
          ).and_return(double(save: true, email_sent?: true))
        end

        it 'it stores the signed in email address in the session' do
          do_post
          expect(session[:confirmation_email_address]).to eq('foo@bar.com')
        end
      end
    end

    context 'when the authentication was unsuccessful' do
      before do
        expect(warden).to receive(:authenticate!).and_call_original
        expect(C100App::SaveApplicationForLater).not_to receive(:new)
      end

      it 'does not sign a user in and re-renders the page' do
        do_post
        expect(subject).to render_template(:new)
      end
    end
  end

  describe '#destroy' do
    it 'redirects to the logged out page' do
      delete :destroy
      expect(subject).to redirect_to(users_login_logged_out_path)
    end
  end

  describe '#logged_out' do
    it 'renders the expected page' do
      get :logged_out
      expect(response).to render_template(:logged_out)
    end
  end

  describe '#save_confirmation' do
    it 'renders the expected page' do
      get :save_confirmation
      expect(response).to render_template(:save_confirmation)
    end
  end
end
