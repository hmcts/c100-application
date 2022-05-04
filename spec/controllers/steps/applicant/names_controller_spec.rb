require 'rails_helper'

RSpec.describe Steps::Applicant::NamesController, type: :controller do
  it_behaves_like 'a names CRUD step controller',
                  Steps::Applicant::NamesSplitForm,
                  C100App::ApplicantDecisionTree,
                  Applicant
end
