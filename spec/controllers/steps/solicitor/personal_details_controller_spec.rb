require 'rails_helper'

RSpec.describe Steps::Solicitor::PersonalDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Solicitor::PersonalDetailsForm, C100App::SolicitorDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Solicitor::PersonalDetailsForm
end
