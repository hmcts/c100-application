require 'rails_helper'

RSpec.describe Steps::Solicitor::ContactDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Solicitor::ContactDetailsForm, C100App::SolicitorDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Solicitor::ContactDetailsForm
end
