require 'rails_helper'

RSpec.describe Steps::Miam::AttendedController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::AttendedForm, C100App::MiamDecisionTree
end
