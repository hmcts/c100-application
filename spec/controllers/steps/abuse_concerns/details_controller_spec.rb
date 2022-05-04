require 'rails_helper'

RSpec.describe Steps::AbuseConcerns::DetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AbuseConcerns::DetailsForm, C100App::AbuseConcernsDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::AbuseConcerns::DetailsForm
end
