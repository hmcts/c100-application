require 'rails_helper'

RSpec.describe Steps::Opening::WarningController, type: :controller do
  let!(:existing_c100) { C100Application.create(status: status, navigation_stack: []) }

  before do
    allow(controller).to receive(:current_c100_application).and_return(existing_c100)
  end

  describe '#show' do
    context 'when an existing application exists in session' do
      let(:status) { :in_progress }

      it 'responds with HTTP success' do
        get :show, session: { c100_application_id: existing_c100.id }
        expect(response).to be_successful
      end

      it 'does not update the navigation stack' do
        expect(controller).not_to receive(:update_navigation_stack)
        get :show, session: { c100_application_id: existing_c100.id }
      end
    end

    context 'when no application exists in session' do
      let!(:existing_c100) { nil }

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end
  end
end
