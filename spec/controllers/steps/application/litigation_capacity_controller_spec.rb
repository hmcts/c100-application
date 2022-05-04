require 'rails_helper'

RSpec.describe Steps::Application::LitigationCapacityController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::LitigationCapacityForm, C100App::ApplicationDecisionTree
end
