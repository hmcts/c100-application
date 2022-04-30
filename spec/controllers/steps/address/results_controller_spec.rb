require 'rails_helper'

RSpec.describe Steps::Address::ResultsController, type: :controller do
  let(:lookup_service) { spy(C100App::AddressLookupService) }

  before do
    allow(C100App::AddressLookupService).to receive(:new).and_return(lookup_service)
  end

  it_behaves_like 'an intermediate step controller', Steps::Address::ResultsForm, C100App::AddressDecisionTree

  describe 'address results' do
    let(:c100_application) { C100Application.new(status: :in_progress) }

    before do
      allow(controller).to receive(:current_c100_application).and_return(c100_application)

      allow(lookup_service).to receive(:result).and_return(%w(address1 address2))
      allow(lookup_service).to receive(:success?).and_return(true)
    end

    context 'on edit' do
      it 'calls the lookup service to retrieve the addresses' do
        get :edit, session: {c100_application_id: 'whatever'}

        expect(assigns[:addresses]).to match_array(%w(address1 address2))
        expect(assigns[:successful_lookup]).to eq(true)
      end
    end

    context 'on update (needed for errors)' do
      it 'calls the lookup service to retrieve the addresses' do
        # provoke an error with wrong params
        put :update, params: {whatever: ''}, session: {c100_application_id: 'whatever'}

        expect(assigns[:addresses]).to match_array(%w(address1 address2))
        expect(assigns[:successful_lookup]).to eq(true)

        expect(response).to render_template(:edit)
      end
    end
  end
end
