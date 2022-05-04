module Steps
  module Miam
    class ExemptionClaimController < Steps::MiamStepController
      def edit
        @form_object = ExemptionClaimForm.new(
          c100_application: current_c100_application,
          miam_exemption_claim: current_c100_application.miam_exemption_claim
        )
      end

      def update
        update_and_advance(ExemptionClaimForm)
      end
    end
  end
end
