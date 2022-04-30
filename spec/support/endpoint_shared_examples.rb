require 'spec_helper'

RSpec.shared_examples 'an end point step controller' do
  describe '#show' do
    context 'when no case exists in the session' do
      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when a case is in progress' do
      let(:c100_application) { C100Application.create(case_type: CaseType::CHILD_ARRANGEMENTS) }

      it 'is successful' do
        get :show, session: { c100_application_id: c100_application.id }
        expect(response).to render_template(:show)
      end
    end
  end
end

RSpec.shared_examples 'an end of navigation controller' do
  context 'navigation stack' do
    let(:c100_application) { C100Application.create(case_type: CaseType::CHILD_ARRANGEMENTS, navigation_stack: ['/not', '/empty']) }

    it 'clears the navigation stack' do
      get :show, session: {c100_application_id: c100_application.id}

      c100_application.reload
      expect(c100_application.navigation_stack).to be_empty
    end
  end
end
