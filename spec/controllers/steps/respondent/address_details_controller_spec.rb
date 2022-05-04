require 'rails_helper'

RSpec.describe Steps::Respondent::AddressDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Respondent::AddressDetailsForm, C100App::RespondentDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Respondent::AddressDetailsForm
end
