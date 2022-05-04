require 'rails_helper'

RSpec.shared_examples 'checks the validity of the current c100 application' do
  context 'when there is no case in the session' do
    let(:current_c100_application) { nil }

    it 'redirects to the invalid session error page' do
      expect(response).to redirect_to(invalid_session_errors_path)
    end
  end
end

RSpec.shared_examples 'checks the validity of the current c100 application on create' do |additional_params|
  describe 'c100 application checks on create' do
    before do
      additional_params ||= {}
      allow(subject).to receive(:current_c100_application).and_return(current_c100_application)
      post :create, params: additional_params
    end

    include_examples 'checks the validity of the current c100 application'
  end
end

RSpec.shared_examples 'checks the validity of the current c100 application on destroy' do |additional_params|
  describe 'c100 application checks on destroy' do
    before do
      additional_params ||= {}
      allow(subject).to receive(:current_c100_application).and_return(current_c100_application)
      delete :destroy, params: {id: 'anything'}.merge(additional_params)
    end

    include_examples 'checks the validity of the current c100 application'
  end
end
