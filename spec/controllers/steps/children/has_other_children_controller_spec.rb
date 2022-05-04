require 'rails_helper'

RSpec.describe Steps::Children::HasOtherChildrenController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::HasOtherChildrenForm, C100App::ChildrenDecisionTree
end
