module Steps
  module Application
    class UrgentHearingController < Steps::ApplicationStepController
      def edit
        @form_object = UrgentHearingForm.new(
          c100_application: current_c100_application,
          urgent_hearing: current_c100_application.urgent_hearing
        )
      end

      def update
        update_and_advance(UrgentHearingForm)
      end
    end
  end
end
