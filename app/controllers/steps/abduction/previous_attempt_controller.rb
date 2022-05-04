module Steps
  module Abduction
    class PreviousAttemptController < Steps::AbductionStepController
      def edit
        @form_object = PreviousAttemptForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(PreviousAttemptForm)
      end
    end
  end
end
