module Steps
  module AttendingCourt
    class SpecialAssistanceController < Steps::AttendingCourtStepController
      def edit
        @form_object = SpecialAssistanceForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(SpecialAssistanceForm, as: :special_assistance)
      end
    end
  end
end
