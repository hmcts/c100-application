module Steps
  module Alternatives
    class CollaborativeLawForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :alternative_collaborative_law
    end
  end
end
