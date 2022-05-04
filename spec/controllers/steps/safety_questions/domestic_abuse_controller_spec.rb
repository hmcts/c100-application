require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::DomesticAbuseController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::DomesticAbuseForm, C100App::SafetyQuestionsDecisionTree
end
