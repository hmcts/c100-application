require 'rails_helper'

RSpec.describe Steps::AttendingCourt::LanguageController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AttendingCourt::LanguageForm, C100App::AttendingCourtDecisionTree
  it_behaves_like 'a step that can fast-forward to check your answers', Steps::AttendingCourt::LanguageForm
end
