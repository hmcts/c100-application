require 'rails_helper'

RSpec.describe Steps::CourtOrders::HasOrdersController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::CourtOrders::HasOrdersForm, C100App::CourtOrdersDecisionTree
end
