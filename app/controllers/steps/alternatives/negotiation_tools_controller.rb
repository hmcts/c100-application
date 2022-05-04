module Steps
  module Alternatives
    class NegotiationToolsController < Steps::AlternativesStepController
      def edit
        @form_object = NegotiationToolsForm.build(current_c100_application)
      end

      def update
        update_and_advance(NegotiationToolsForm, as: :negotiation_tools)
      end
    end
  end
end
