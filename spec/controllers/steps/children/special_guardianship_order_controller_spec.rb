require 'rails_helper'

RSpec.describe Steps::Children::SpecialGuardianshipOrderController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::SpecialGuardianshipOrderForm, C100App::ChildrenDecisionTree
end
