module Steps
  module AttendingCourt
    class IntermediaryController < Steps::AttendingCourtStepController
      def edit
        @form_object = IntermediaryForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(IntermediaryForm, as: :intermediary)
      end
    end
  end
end
