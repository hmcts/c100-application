module Steps
  module Alternatives
    class LawyerNegotiationController < Steps::AlternativesStepController
      def edit
        @form_object = LawyerNegotiationForm.build(current_c100_application)
      end

      def update
        update_and_advance(LawyerNegotiationForm, as: :lawyer_negotiation)
      end
    end
  end
end
