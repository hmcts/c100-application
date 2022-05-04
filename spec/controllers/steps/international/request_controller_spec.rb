require 'rails_helper'

RSpec.describe Steps::International::RequestController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::International::RequestForm, C100App::InternationalDecisionTree
end
