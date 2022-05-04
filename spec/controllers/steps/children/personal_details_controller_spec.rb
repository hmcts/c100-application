require 'rails_helper'

RSpec.describe Steps::Children::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Children::PersonalDetailsForm, C100App::ChildrenDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Children::PersonalDetailsForm
end
