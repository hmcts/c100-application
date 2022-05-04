module Steps
  module Alternatives
    class LawyerNegotiationForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :alternative_lawyer_negotiation
    end
  end
end
