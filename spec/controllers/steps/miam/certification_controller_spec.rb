require 'rails_helper'

RSpec.describe Steps::Miam::CertificationController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::CertificationForm, C100App::MiamDecisionTree
end
