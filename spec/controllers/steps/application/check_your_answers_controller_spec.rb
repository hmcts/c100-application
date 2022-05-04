require 'rails_helper'

RSpec.describe Steps::Application::CheckYourAnswersController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::DeclarationForm, C100App::ApplicationDecisionTree

  describe '#edit' do
    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create(status: :in_progress) }

      it 'assigns the HTML presenter' do
        get :edit, session: { c100_application_id: existing_case.id }

        expect(response).to be_successful
        expect(assigns[:presenter]).to be_an_instance_of(Summary::HtmlPresenter)
      end
    end
  end

  describe '#resume' do
    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create(status: :in_progress) }

      it 'assigns the HTML presenter' do
        get :resume, session: { c100_application_id: existing_case.id }

        expect(response).to render_template(:resume)
        expect(assigns[:presenter]).to be_an_instance_of(Summary::HtmlPresenter)
      end
    end
  end
end
