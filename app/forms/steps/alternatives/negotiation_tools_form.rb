module Steps
  module Alternatives
    class NegotiationToolsForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :alternative_negotiation_tools
    end
  end
end
