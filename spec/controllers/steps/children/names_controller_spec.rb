require 'rails_helper'

RSpec.describe Steps::Children::NamesController, type: :controller do
  it_behaves_like 'a names CRUD step controller',
                  Steps::Children::NamesSplitForm,
                  C100App::ChildrenDecisionTree,
                  Child
end
