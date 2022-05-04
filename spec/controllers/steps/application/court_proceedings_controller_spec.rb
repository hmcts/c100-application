require 'rails_helper'

RSpec.describe Steps::Application::CourtProceedingsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::CourtProceedingsForm, C100App::ApplicationDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Application::CourtProceedingsForm
end
