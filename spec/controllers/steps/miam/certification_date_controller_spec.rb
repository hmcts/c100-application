require 'rails_helper'

RSpec.describe Steps::Miam::CertificationDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Miam::CertificationDateForm, C100App::MiamDecisionTree
end
