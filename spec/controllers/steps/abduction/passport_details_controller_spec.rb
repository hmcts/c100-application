require 'rails_helper'

RSpec.describe Steps::Abduction::PassportDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Abduction::PassportDetailsForm, C100App::AbductionDecisionTree
end
