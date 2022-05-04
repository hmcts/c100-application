module Steps
  module Miam
    class AttendedController < Steps::MiamStepController
      def edit
        @form_object = AttendedForm.new(
          c100_application: current_c100_application,
          miam_attended: current_c100_application.miam_attended
        )
      end

      def update
        update_and_advance(AttendedForm)
      end
    end
  end
end
