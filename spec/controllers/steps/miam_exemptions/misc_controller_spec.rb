require 'rails_helper'

RSpec.describe Steps::MiamExemptions::MiscController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::MiamExemptions::MiscForm, C100App::MiamExemptionsDecisionTree
end
