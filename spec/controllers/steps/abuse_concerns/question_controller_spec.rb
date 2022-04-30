require 'rails_helper'

RSpec.describe Steps::AbuseConcerns::QuestionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AbuseConcerns::QuestionForm, C100App::AbuseConcernsDecisionTree
end
