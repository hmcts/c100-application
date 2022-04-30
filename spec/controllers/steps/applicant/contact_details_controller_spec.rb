require 'rails_helper'

RSpec.describe Steps::Applicant::ContactDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Applicant::ContactDetailsForm, C100App::ApplicantDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Applicant::ContactDetailsForm
end
