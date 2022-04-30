require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::SubstanceAbuseController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::SubstanceAbuseForm, C100App::SafetyQuestionsDecisionTree
end
