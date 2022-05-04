require 'rails_helper'

RSpec.describe Steps::Children::AdditionalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::AdditionalDetailsForm, C100App::ChildrenDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Children::AdditionalDetailsForm
end
