require 'rails_helper'

RSpec.describe Steps::Application::PermissionDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::PermissionDetailsForm, C100App::ApplicationDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Application::PermissionDetailsForm
end
