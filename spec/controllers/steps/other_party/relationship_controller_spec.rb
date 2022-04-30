require 'rails_helper'

RSpec.describe Steps::OtherParty::RelationshipController, type: :controller do
  it_behaves_like 'a relationship step controller', Steps::Shared::RelationshipForm, C100App::OtherPartyDecisionTree
end
