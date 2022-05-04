require 'rails_helper'

RSpec.describe Steps::Miam::CertificationDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::CertificationDetailsForm, C100App::MiamDecisionTree
end
