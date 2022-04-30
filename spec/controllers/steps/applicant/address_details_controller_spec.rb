require 'rails_helper'

RSpec.describe Steps::Applicant::AddressDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Applicant::AddressDetailsForm, C100App::ApplicantDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Applicant::AddressDetailsForm
end
