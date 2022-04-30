require 'rails_helper'

RSpec.describe Steps::Children::ResidenceController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::ResidenceForm, C100App::ChildrenDecisionTree
end
