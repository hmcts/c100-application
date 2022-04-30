require 'rails_helper'

RSpec.describe Steps::Address::LookupController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Address::LookupForm, C100App::AddressDecisionTree
end
