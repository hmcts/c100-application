require 'rails_helper'

RSpec.describe Steps::MiamExemptions::DomesticController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::MiamExemptions::DomesticForm, C100App::MiamExemptionsDecisionTree
end
