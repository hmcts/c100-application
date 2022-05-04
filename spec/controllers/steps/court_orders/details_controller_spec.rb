require 'rails_helper'

RSpec.describe Steps::CourtOrders::DetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::CourtOrders::DetailsForm, C100App::CourtOrdersDecisionTree
end
