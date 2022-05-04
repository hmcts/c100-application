require 'rails_helper'

RSpec.describe Steps::Abduction::PreviousAttemptController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Abduction::PreviousAttemptForm, C100App::AbductionDecisionTree
end
