require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::RiskOfAbductionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::RiskOfAbductionForm, C100App::SafetyQuestionsDecisionTree
end
