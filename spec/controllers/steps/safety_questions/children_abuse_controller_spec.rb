require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::ChildrenAbuseController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::ChildrenAbuseForm, C100App::SafetyQuestionsDecisionTree
end
