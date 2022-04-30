module Steps
  module Abduction
    class RiskDetailsController < Steps::AbductionStepController
      def edit
        @form_object = RiskDetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(RiskDetailsForm)
      end
    end
  end
end
