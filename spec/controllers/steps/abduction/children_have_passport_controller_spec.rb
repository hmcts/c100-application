require 'rails_helper'

RSpec.describe Steps::Abduction::ChildrenHavePassportController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Abduction::ChildrenHavePassportForm, C100App::AbductionDecisionTree
end
