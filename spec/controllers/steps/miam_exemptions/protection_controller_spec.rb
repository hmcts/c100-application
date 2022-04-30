require 'rails_helper'

RSpec.describe Steps::MiamExemptions::ProtectionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::MiamExemptions::ProtectionForm, C100App::MiamExemptionsDecisionTree
end
