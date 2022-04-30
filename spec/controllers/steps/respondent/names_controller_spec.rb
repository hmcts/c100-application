require 'rails_helper'

RSpec.describe Steps::Respondent::NamesController, type: :controller do
  it_behaves_like 'a names CRUD step controller',
                  Steps::Respondent::NamesSplitForm,
                  C100App::RespondentDecisionTree,
                  Respondent
end
