require 'rails_helper'

RSpec.describe Steps::Applicant::UnderAgeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::UnderAgeForm, C100App::ApplicantDecisionTree

  context 'when user is under age' do
    let!(:existing_c100) do
      C100Application.create(status: :in_progress)
    end

    let(:court) {
      double(
        'Court',
        name: 'Test court',
        email: 'court@example.com',
        slug: 'test-court'
      )
    }

    before do
      allow_any_instance_of(C100Application).to receive(:court).and_return(court)
    end

    it 'assigns the court data' do
      get :edit, session: { c100_application_id: existing_c100.id }

      expect(assigns[:court]).to eq(court)
      expect(assigns[:_current_c100_application]).to eq(existing_c100)
    end
  end
end
