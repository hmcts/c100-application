require 'rails_helper'

RSpec.describe Steps::Opening::ResearchConsentController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Opening::ResearchConsentForm, C100App::OpeningDecisionTree
end
