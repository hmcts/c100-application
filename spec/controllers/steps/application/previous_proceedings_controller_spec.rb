require 'rails_helper'

RSpec.describe Steps::Application::PreviousProceedingsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::PreviousProceedingsForm, C100App::ApplicationDecisionTree
end
