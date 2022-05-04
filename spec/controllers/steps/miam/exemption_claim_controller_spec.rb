require 'rails_helper'

RSpec.describe Steps::Miam::ExemptionClaimController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::ExemptionClaimForm, C100App::MiamDecisionTree
end
