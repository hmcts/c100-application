require 'rails_helper'

RSpec.describe Steps::Petition::ProtectionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Petition::ProtectionForm, C100App::PetitionDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::Petition::ProtectionForm
end
