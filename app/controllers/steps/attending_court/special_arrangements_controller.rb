module Steps
  module AttendingCourt
    class SpecialArrangementsController < Steps::AttendingCourtStepController
      def edit
        @form_object = SpecialArrangementsForm.build(
          c100_application: current_c100_application
        )
      end

      def update
        update_and_advance(SpecialArrangementsForm, as: :special_arrangements)
      end
    end
  end
end
