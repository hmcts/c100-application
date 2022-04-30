module Steps
  module Alternatives
    class MediationForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :alternative_mediation
    end
  end
end
