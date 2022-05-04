require 'rails_helper'

RSpec.describe Steps::Miam::MediatorExemptionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::MediatorExemptionForm, C100App::MiamDecisionTree
end
