require 'rails_helper'

RSpec.describe Steps::OtherParty::NamesController, type: :controller do
  it_behaves_like 'a names CRUD step controller',
                  Steps::OtherParty::NamesSplitForm,
                  C100App::OtherPartyDecisionTree,
                  OtherParty
end
