require 'rails_helper'

RSpec.describe Steps::Alternatives::CourtController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Alternatives::CourtForm, C100App::AlternativesDecisionTree
end
