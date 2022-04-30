require 'rails_helper'

RSpec.describe Steps::Respondent::HasOtherPartiesController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Respondent::HasOtherPartiesForm, C100App::RespondentDecisionTree
end
