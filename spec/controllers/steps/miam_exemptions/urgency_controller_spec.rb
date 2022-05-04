require 'rails_helper'

RSpec.describe Steps::MiamExemptions::UrgencyController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::MiamExemptions::UrgencyForm, C100App::MiamExemptionsDecisionTree
end
