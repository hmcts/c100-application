require 'rails_helper'

RSpec.describe Steps::Applicant::HasSolicitorController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Applicant::HasSolicitorForm, C100App::ApplicantDecisionTree
end
