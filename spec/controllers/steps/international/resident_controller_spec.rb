require 'rails_helper'

RSpec.describe Steps::International::ResidentController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::International::ResidentForm, C100App::InternationalDecisionTree
end
