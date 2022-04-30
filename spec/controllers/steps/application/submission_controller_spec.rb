require 'rails_helper'

RSpec.describe Steps::Application::SubmissionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::SubmissionForm, C100App::ApplicationDecisionTree
end
