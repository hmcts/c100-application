require 'rails_helper'

RSpec.describe Steps::Permission::QuestionController, type: :controller do
  # There will be 9 different form classes but all behave the same, so we just pick one
  let(:form_class) { Steps::Permission::ParentalResponsibilityForm }
  let(:decision_tree_class) { C100App::PermissionDecisionTree }

  let(:question_name) { 'parental_responsibility' }
  let(:relationship_id) { 'uuid-123' }

  let(:params) { { question_name: question_name, relationship_id: relationship_id } }

  let(:relationships_scope) { double('relationships_scope') }
  let(:relationship) { Relationship.new }

  before do
    allow_any_instance_of(C100Application).to receive(:relationships).and_return(relationships_scope)
    allow(relationships_scope).to receive(:find_by!).with(id: relationship_id).and_return(relationship)
  end

  describe '#edit' do
    context 'when no case exists in the session yet' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :edit, params: params
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      let!(:existing_case) { C100Application.create(status: :in_progress) }

      after do
        existing_case.destroy
      end

      context 'when the question is unknown' do
        let(:question_name) { 'foobar' }

        it 'raises an exception' do
          expect {
            get :edit, params: params, session: { c100_application_id: existing_case.id }
          }.to raise_error(NameError, 'uninitialized constant Steps::Permission::FoobarForm')
        end
      end

      it 'responds with HTTP success' do
        expect(
          form_class
        ).to receive(:build).with(
          relationship, c100_application: existing_case
        )

        get :edit, params: params, session: { c100_application_id: existing_case.id }
        expect(response).to be_successful
      end
    end
  end

  describe '#update' do
    let(:form_object) { instance_double(form_class, attributes: { foo: double }) }
    let(:form_class_params_name) { form_class.name.underscore }
    let(:expected_params) { params.merge({ form_class_params_name => { foo: 'bar' } }) }

    context 'when there is no case in the session' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        put :update, params: expected_params
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case in progress is in the session' do
      let!(:existing_case) { C100Application.create(status: :in_progress) }

      before do
        allow(form_class).to receive(:new).and_return(form_object)
      end

      after do
        existing_case.destroy
      end

      context 'when the form saves successfully' do
        before do
          expect(form_object).to receive(:save).and_return(true)
        end

        let(:decision_tree) { instance_double(decision_tree_class, destination: '/expected_destination') }

        it 'asks the decision tree for the next destination and redirects there' do
          expect(decision_tree_class).to receive(:new).and_return(decision_tree)
          put :update, params: expected_params, session: { c100_application_id: existing_case.id }
          expect(subject).to redirect_to('/expected_destination')
        end
      end

      context 'when the form fails to save' do
        before do
          expect(form_object).to receive(:save).and_return(false)
        end

        it 'renders the question page again' do
          put :update, params: expected_params, session: { c100_application_id: existing_case.id }
          expect(subject).to render_template(:edit)
        end
      end
    end
  end
end
