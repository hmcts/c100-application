require 'rails_helper'

RSpec.describe Steps::Abduction::PreviousAttemptDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Abduction::PreviousAttemptDetailsForm, C100App::AbductionDecisionTree
end
