require 'rails_helper'

RSpec.describe Steps::MiamExemptions::AdrController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::MiamExemptions::AdrForm, C100App::MiamExemptionsDecisionTree
end
