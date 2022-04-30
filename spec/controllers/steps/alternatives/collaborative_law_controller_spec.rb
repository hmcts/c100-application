require 'rails_helper'

RSpec.describe Steps::Alternatives::CollaborativeLawController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Alternatives::CollaborativeLawForm, C100App::AlternativesDecisionTree
end
