require 'rails_helper'

RSpec.describe Steps::Abduction::RiskDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Abduction::RiskDetailsForm, C100App::AbductionDecisionTree
end
