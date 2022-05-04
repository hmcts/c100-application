module Steps
  module Abduction
    class PreviousAttemptDetailsController < Steps::AbductionStepController
      def edit
        @form_object = PreviousAttemptDetailsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(PreviousAttemptDetailsForm, as: :previous_attempt_details)
      end
    end
  end
end
