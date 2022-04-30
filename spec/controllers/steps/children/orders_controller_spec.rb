require 'rails_helper'

RSpec.describe Steps::Children::OrdersController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::OrdersForm, C100App::ChildrenDecisionTree
end
