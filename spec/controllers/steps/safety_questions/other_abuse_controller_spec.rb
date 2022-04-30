require 'rails_helper'

RSpec.describe Steps::SafetyQuestions::OtherAbuseController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::SafetyQuestions::OtherAbuseForm, C100App::SafetyQuestionsDecisionTree
end
