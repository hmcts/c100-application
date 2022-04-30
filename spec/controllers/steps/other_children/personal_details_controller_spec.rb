require 'rails_helper'

RSpec.describe Steps::OtherChildren::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::OtherChildren::PersonalDetailsForm, C100App::OtherChildrenDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::OtherChildren::PersonalDetailsForm
end
