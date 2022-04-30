require 'rails_helper'

RSpec.describe Steps::Alternatives::MediationController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Alternatives::MediationForm, C100App::AlternativesDecisionTree
end
