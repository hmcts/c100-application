require 'rails_helper'

RSpec.describe Steps::Application::PermissionSoughtController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::PermissionSoughtForm, C100App::ApplicationDecisionTree
end
