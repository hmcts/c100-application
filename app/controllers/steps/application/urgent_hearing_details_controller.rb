module Steps
  module Application
    class UrgentHearingDetailsController < Steps::ApplicationStepController
      def edit
        @form_object = UrgentHearingDetailsForm.build(current_c100_application)
      end

      def update
        update_and_advance(UrgentHearingDetailsForm, as: :urgent_hearing_details)
      end
    end
  end
end
