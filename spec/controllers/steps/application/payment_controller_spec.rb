require 'rails_helper'

RSpec.describe Steps::Application::PaymentController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Application::PaymentForm, C100App::ApplicationDecisionTree
end
