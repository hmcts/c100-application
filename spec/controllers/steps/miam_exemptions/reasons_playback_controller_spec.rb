require 'rails_helper'

RSpec.describe Steps::MiamExemptions::ReasonsPlaybackController, type: :controller do
  it_behaves_like 'a show step controller'

  describe '#show' do
    let(:c100_application) { instance_double(C100Application, miam_exemption: miam_exemption) }
    let(:miam_exemption) { double('miam_exemption').as_null_object }

    before do
      allow(controller).to receive(:current_c100_application).and_return(c100_application)
      allow(controller).to receive(:update_navigation_stack)
    end

    it 'assigns the presenter' do
      expect(MiamExemptionsPresenter).to receive(:new).with(miam_exemption).and_call_original

      get :show

      expect(response).to render_template(:show)
      expect(assigns[:presenter]).to be_a(MiamExemptionsPresenter)
    end
  end
end
