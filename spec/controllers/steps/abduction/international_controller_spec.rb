require 'rails_helper'

RSpec.describe Steps::Abduction::InternationalController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Abduction::InternationalForm, C100App::AbductionDecisionTree
end
