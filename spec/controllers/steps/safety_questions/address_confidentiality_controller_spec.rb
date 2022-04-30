require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::AddressConfidentialityController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::AddressConfidentialityForm, C100App::SafetyQuestionsDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::SafetyQuestions::AddressConfidentialityForm
end
