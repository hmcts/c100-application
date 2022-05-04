require 'rails_helper'

RSpec.describe Steps::OtherChildren::NamesController, type: :controller do
  it_behaves_like 'a names CRUD step controller',
                  Steps::OtherChildren::NamesSplitForm,
                  C100App::OtherChildrenDecisionTree,
                  OtherChild
end
