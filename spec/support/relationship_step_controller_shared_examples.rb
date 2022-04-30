require 'rails_helper'

RSpec.shared_examples 'a relationship step controller' do |form_class, decision_tree_class|
  let(:relationships) { double('relationships').as_null_object }
  let(:minors)        { double('minors').as_null_object }
  let(:person)        { double('Person') }
  let(:child)         { double('Child') }
  let(:relationship)  { Relationship.new }

  let(:existing_case) { instance_double(C100Application, relationships: relationships, minors: minors) }

  # This is a side effect of everything being a double, we have to do a lot of 'setup', but all this
  # is not part of these tests and we don't need to test the functionality, just trust it.
  before do
    allow(existing_case).to receive(:completed?).and_return(false)
    allow(existing_case).to receive(:screening?).and_return(false)
    allow(controller).to receive(:current_c100_application).and_return(existing_case)
    allow(controller).to receive(:update_navigation_stack)
  end

  describe '#update' do
    let(:form_object) { instance_double(form_class, attributes: { foo: double }) }
    let(:form_class_params_name) { form_class.name.underscore }
    let(:expected_params) { { form_class_params_name => { foo: 'bar' }, id: '123', child_id: '123' } }

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
      before do
        allow(form_class).to receive(:new).and_return(form_object)
        allow(controller).to receive(:current_record).and_return(person)
        allow(minors).to receive(:find).with('123').and_return(child)

        expect(relationships).to receive(:find_or_initialize_by).with(person: person, minor: child)
      end

      context 'when the form saves successfully' do
        before do
          allow(form_object).to receive(:save).and_return(true)
        end

        let(:decision_tree) { instance_double(decision_tree_class, destination: '/expected_destination') }

        it 'asks the decision tree for the next destination and redirects there' do
          expect(decision_tree_class).to receive(:new).and_return(decision_tree)
          put :update, params: expected_params
          expect(subject).to redirect_to('/expected_destination')
        end
      end

      context 'when the form fails to save' do
        before do
          allow(form_object).to receive(:save).and_return(false)
        end

        it 'renders the question page again' do
          put :update, params: expected_params
          expect(subject).to render_template(:edit)
        end
      end
    end
  end

  describe '#edit' do
    context 'when no case exists in the session yet' do
      before do
        # Needed because some specs that include these examples stub current_c100_application,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_c100_application).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :edit, params: { id: '123', child_id: '123' }
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case exists in the session' do
      before do
        allow(controller).to receive(:current_record).and_return(person)
        allow(minors).to receive(:find).with('123').and_return(child)

        allow(relationships).to receive(:find_or_initialize_by).with(
          person: person, minor: child
        ).and_return(relationship)
      end

      it 'responds with HTTP success' do
        get :edit, params: { id: '123', child_id: '123' }
        expect(response).to be_successful
      end
    end
  end
end
