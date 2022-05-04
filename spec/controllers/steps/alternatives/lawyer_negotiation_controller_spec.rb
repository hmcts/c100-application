require 'rails_helper'

RSpec.describe Steps::Alternatives::LawyerNegotiationController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Alternatives::LawyerNegotiationForm, C100App::AlternativesDecisionTree
end
