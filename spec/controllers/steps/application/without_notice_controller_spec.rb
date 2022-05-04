require 'rails_helper'

RSpec.describe Steps::Application::WithoutNoticeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::WithoutNoticeForm, C100App::ApplicationDecisionTree
end
