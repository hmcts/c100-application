require 'rails_helper'

RSpec.describe Steps::Opening::ChildProtectionCasesController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Opening::ChildProtectionCasesForm, C100App::OpeningDecisionTree
end
