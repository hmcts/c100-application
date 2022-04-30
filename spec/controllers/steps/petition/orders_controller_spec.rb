require 'rails_helper'

RSpec.describe Steps::Petition::OrdersController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Petition::OrdersForm, C100App::PetitionDecisionTree
end
