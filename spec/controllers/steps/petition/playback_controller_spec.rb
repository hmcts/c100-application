require 'rails_helper'

RSpec.describe Steps::Petition::PlaybackController, type: :controller do
  it_behaves_like 'a show step controller'

  describe '#show' do
    let(:c100_application) { instance_double(C100Application) }
    let(:safety_concerns)  { false }

    before do
      allow(c100_application).to receive(:has_safety_concerns?).and_return(safety_concerns)
      allow(controller).to receive(:current_c100_application).and_return(c100_application)
      allow(controller).to receive(:update_navigation_stack)
    end

    it 'assigns the presenter' do
      expect(PetitionPresenter).to receive(:new).with(c100_application).and_call_original

      get :show

      expect(response).to render_template(:show)
      expect(assigns[:petition]).to be_a(PetitionPresenter)
    end

    context 'assigns the next step path' do
      context 'when there are safety concerns' do
        let(:safety_concerns) { true }

        it 'assigns the correct next step path' do
          get :show

          expect(response).to render_template(:show)
          expect(assigns[:next_step_path]).to eq('/steps/petition/protection')
        end
      end

      context 'when there are no safety concerns' do
        it 'assigns the correct next step path' do
          get :show

          expect(response).to render_template(:show)
          expect(assigns[:next_step_path]).to eq('/steps/alternatives/court')
        end
      end
    end
  end
end
