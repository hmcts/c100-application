require 'rails_helper'

RSpec.describe Steps::Application::UrgentHearingController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::UrgentHearingForm, C100App::ApplicationDecisionTree
end
