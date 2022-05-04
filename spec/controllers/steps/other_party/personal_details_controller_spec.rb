require 'rails_helper'

RSpec.describe Steps::OtherParty::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::OtherParty::PersonalDetailsForm, C100App::OtherPartyDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::OtherParty::PersonalDetailsForm
end
